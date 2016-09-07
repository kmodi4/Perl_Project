#!/usr/bin/perl  -w
use DBI;
#definition of variables   http://cpansearch.perl.org/src/KMX/Win32-GUI-1.11/scripts/win32-gui-demos.pl
$db="mytest";
$host="localhost";
$user="root";
$password="";  # the root password

#connect to MySQL database
my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
                           $user,
                           $password) 
                           or die "Can't connect to database: $DBI::errstr\n";


#prepare the query
my $sth = $dbh->prepare( "SELECT * FROM reg");

#execute the query
$sth->execute( );
## Retrieve the results of a row of data and print
print "\tQuery results:\n================================================\n";

while ( my @row = $sth->fetchrow_array( ) )  {
         print "@row\n";
}
warn "Problem in retrieving results", $sth->errstr( ), "\n"
        if $sth->err( );
        
        #disconnect  from database 
$dbh->disconnect or warn "Disconnection error: $DBI::errstr\n";

exit;