#!/user/bin/bash

PostgreSQL_Intallation(){
    echo "PostgreSQL Installation... "
    sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    sudo yum install postgresql12 postgresql12-contrib postgresql12-server -y
    sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
    sudo systemctl start postgresql-12
    sudo systemctl enable postgresql-12
    
}
PostgreSQL_Intallation
echo "Postgres12 Installed successfully..."

echo "Postgres table creatioon and data insertion..."
PostgreSQL_Data_Loading(){   
pass='Pswd123'     
    sudo yum install git -y
    sudo git clone https://github.com/Gaurav07Patel/PostgreSQL.git /tmp/Customers
    sudo chmod 755 /tmp/Customers/Customers
    sudo chown postgres /tmp/Customers/Customers
    sudo su
    #sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g"  /var/lib/pgsql/12/data/postgresql.conf                                                                                        
         # local   all             all                                     peer local   all             all                                     peer
    sed "s/local   all             all                                     peer/local   all             postgres                                trust/g" /var/lib/pgsql/12/data/pg_hba.conf
    sudo systemctl restart postgresql-12
    sudo su
    su - postgres 
    psql -U postgres -c "ALTER USER postgres with password '$pass';"
    exit
          #local   all             all                                     peer  local   all             all                                     peer  
    sed "s/local   all             postgres                                trust/local   all             postgres                                md5/g" /var/lib/pgsql/12/data/pg_hba.conf
    sudo systemctl restart postgresql-12
    su - postgres
    psql -U postgres -W 'Pswd123' -c "Create database yelp;" 
    psql -U postgres -W yelp -c "Create TABLE cr (username text, date date, city text, rating numeric, review text); "
    psql -U postgres -W yelp -c "/copy cr FROM '/home/vagrant/tmp/Customers/Customers' DELIMIER ',' CSV HEADER "
}

PostgreSQL_Data_Loading
echo " Done..."