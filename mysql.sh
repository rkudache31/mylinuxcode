#!/bin/bash
adduser (){
read -p "Enter user name" username
read -p "Enter id"  empid
read -p "Enter the Salary" salinfo
mysql --user="adminuser@mysql123466" --host="mysql123466.mysql.database.azure.com" -pAdmin@1234567<<EOF
use linuxtranning;
insert into emp(empid,name,sal) values ("$empid","$username","$salinfo");
commit;
select * from emp;
EOF
}
deleteuser(){
read -p "Enter id"  empid
mysql --user="adminuser@mysql123466" --host="mysql123466.mysql.database.azure.com" -pAdmin@1234567<<EOF
use linuxtranning;
delete from emp where empid=$empid;
commit;
EOF
}
selectuser(){
read -p "Enter id"  empid
mysql --user="adminuser@mysql123466" --host="mysql123466.mysql.database.azure.com" -pAdmin@1234567<<EOF
use linuxtranning;
select * from emp where empid=$empid;
EOF

}
updateuser(){
read -p "Enter id"  empid
read -p "Revised salary" sal
mysql --user="adminuser@mysql123466" --host="mysql123466.mysql.database.azure.com" -pAdmin@1234567<<EOF
use linuxtranning;
update emp set sal=$sal where empid=$empid;
commit;
EOF
}

read -p "Plesae select below oprion
         1) Add user
         2) Delete user
         3) select user
         4) update user= " inputinfo

case $inputinfo in 
1) adduser ;;
2) deleteuser ;;
3) selectuser ;;
4) updateuser ;;
*) echo "Opps wrong option";;
esac


