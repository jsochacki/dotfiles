#!/bin/bash

sudo apt update
sudo apt-get install -y ansible
sudo apt-get install -y sshpass

# Need ansible 2.9.6+
ANSIBLEVERSION=$(ansible --version | cut -d' ' -f2)
AMAJOR=$(echo $ANSIBLEVERSION | cut -d'.' -f1)
AMINOR=$(echo $ANSIBLEVERSION | cut -d'.' -f2)
ATINY=$(echo $ANSIBLEVERSION | cut -d'.' -f3)

if [ -z $ANSIBLEVERSION ]
then
   echo "ERROR:Ansible is not yet installed on the system"
else
   if [ "$AMAJOR" -lt 2 ]
   then
      echo "ERROR:Ansible major version insufficient: current $AMAJOR required 2"
   fi

   if [ "$AMINOR" -lt 9 ]
   then
      echo "ERROR:Ansible minor version insufficient: current $AMINOR required 9"
   fi

   if [ "$ATINY" -lt 6 ]
   then
      echo "ERROR:Ansible minor version insufficient: current $AMINOR required 6"
   fi
fi

echo "Ansible version $ANSIBLEVERSION sufficient"

# Need python3.5+
PYTHONVERSION=$(python3 -c 'import platform; print(platform.python_version())')
PMAJOR=$(echo $PYTHONVERSION | cut -d'.' -f1)
PMINOR=$(echo $PYTHONVERSION | cut -d'.' -f2)


if [ -z $PYTHONVERSION ]
then
   echo "ERROR:Python is not yet installed on the system"
else
   if [ "$PMAJOR" -lt 3 ]
   then
      echo "ERROR:Python major version insufficient: current $PMAJOR required 3"
   fi

   if [ "$PMINOR" -lt 5 ]
   then
      echo "ERROR:Python minor version insufficient: current $PMINOR required 5"
   fi
fi

echo "Python version $PYTHONVERSION sufficient"
