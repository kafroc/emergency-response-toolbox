# update 2021.02.23

#!/bin/bash

function initial(){
	echo "Doing initial"
	mkdir /tmp/GatherInfo	
	chmod +x ./chkrootkit
	chmod +x ./busybox
}

function chkrootkit_info(){
	echo "Doing chkrootkit"
	./chkrootkit > /tmp/GatherInfo/chkrootkit.log 2>&1
}

function network_info(){
	echo "Gathering network info"
	netstat -tulnp > /tmp/GatherInfo/netstat_tulnp.log 2>&1
	netstat -anp > /tmp/GatherInfo/netstat_anp.log 2>&1
}

function process_info(){
	echo "Gathering process info"
	ps aux > /tmp/GatherInfo/ps_aux.log 2>&1
	ps auxef > /tmp/GatherInfo/ps_auxef.log 2>&1
	top -n 1 > /tmp/GatherInfo/top_n1.log 2>&1
}

function init_info(){
	echo "Gathering init info"
	chkconfig --list > /tmp/GatherInfo/chkconfig_list.log 2>&1
	ls -alt /etc/init* > /tmp/GatherInfo/ls_alt_etc_init.log 2>&1
}

function cron_info(){
	echo "Gathering cron info"

	cat /etc/crontab > /tmp/GatherInfo/crontab.log 2>&1
	cat /etc/anacrontab > /tmp/GatherInfo/anacrontab.log 2>&1
	crontab -l > /tmp/GatherInfo/crontab_l.log 2>&1
	
	cd /etc/cron.d/
	ls -alt > /tmp/GatherInfo/etc_cron.d.log 2>&1
	cat * >> /tmp/GatherInfo/etc_cron.d.log 2>&1
	
	cd /etc/cron.daily/
	ls -alt > /tmp/GatherInfo/etc_cron.daily.log 2>&1
	cat * >> /tmp/GatherInfo/etc_cron.daily.log 2>&1
	
	cd /etc/cron.hourly/
	ls -alt > /tmp/GatherInfo/etc_cron.hourly.log 2>&1
	cat * >> /tmp/GatherInfo/etc_cron.hourly.log 2>&1
	
	cd /etc/cron.monthly/
	ls -alt > /tmp/GatherInfo/etc_cron.monthly.log 2>&1
	cat * >> /tmp/GatherInfo/etc_cron.monthly.log 2>&1
	
	cd /etc/cron.weekly/
	ls -alt > /tmp/GatherInfo/etc_cron.weekly.log 2>&1
	cat * >> /tmp/GatherInfo/etc_cron.weekly.log 2>&1
	
	cd /var/spool/cron/
	ls -alt > /tmp/GatherInfo/var_spool_cron.log 2>&1
	cat * >> /tmp/GatherInfo/var_spool_cron.log 2>&1
	
	cd /var/spool/anacron/
	ls -alt > /tmp/GatherInfo/var_spool_anacron.log 2>&1
	cat * >> /tmp/GatherInfo/var_spool_anacron.log 2>&1
}

function other_info(){
	echo "Gathering other info"
	
	# check system users
	cat /etc/passwd | grep -v nologin > /tmp/GatherInfo/passwd.log 2>&1

	# check dirs with 777 permition
	ls -alt /tmp > /tmp/GatherInfo/tmp.log 2>&1
	ls -alt /var/tmp > /tmp/GatherInfo/var_tmp.log 2>&1
	ls -alt /dev/shm > /tmp/GatherInfo/dev_shm.log 2>&1

	# check ld env
	echo $LD_PRELOAD > /tmp/GatherInfo/LD_PRELOAD.log 2>&1
	cat /etc/ld.so.preload > /tmp/GatherInfo/etc_ld.so.preload.log 2>&1

	# check root ssh config
	ls -alt /root/.ssh > /tmp/GatherInfo/ls_alt_root_.ssh.log 2>&1
	cat /root/.ssh/* > /tmp/GatherInfo/cat_root_.ssh.log 2>&1

	# check bash config
	cat /root/.bash_profile > /tmp/GatherInfo/cat_root_bash_profile.log 2>&1
	cat /root/.bashrc > /tmp/GatherInfo/cat_root_bashrc.log 2>&1
	
	for user in /home/*
	do
		if test -d $user;then
			cat /home/$user/.ssh/* > /tmp/GatherInfo/cat_$user.ssh.log 2>&1
			ls -alt /home/$user > /tmp/GatherInfo/cat_$user.home.log 2>&1
		fi
	done
}

initial
chkrootkit_info
network_info
process_info
init_info
cron_info
other_info

cd /tmp
tar -zcvf GatherInfo.tar.gz GatherInfo

