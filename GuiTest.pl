use Win32::GUI();  # Version 1.06 from CPAN http://a$main->lvinalexander.com/perl/edu/articles/pl010015/
use DBI;

#definition of variables http://cpansearch.perl.org/src/ROBERTMAY/Win32-GUI-1.06/samples/
$db="mytest";
$host="localhost";
$user="root";
$password="";  # the root password

#connect to MySQL database
my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
                           $user,
                           $password) 
                           or die "Can't connect to database: $DBI::errstr\n";

my $main = Win32::GUI::Window->new(
  -name   => 'Main',
  -width  => 485, 
  -height => 550,
  -title  => $0
);



   $font = Win32::GUI::Font->new(
                -name => "Comic Sans MS", 
                -size => 14,
        );
   $font1 = Win32::GUI::Font->new(
                -name => "Comic Sans MS", 
                -size => 18,

        );
   push (@{$tmp},$main->AddLabel(
      -name => "Title",
      -align => "center",
      -font => $font1,
      -pos => [ 50, 49 ],
      -size => [ 300, 35 ],
      -text => "To-DO Application",
      -visible => '1',
            -background => [255,255,255],
            -foreground => [0,0,0],
      ));
   $tmp->[0]->SetImage($Icon);
    $main->AddButton(
                -name => "Button1",
                -text => "Add",
                -font => $font,
                -pos  => [ 330, 120 ],
        );
   
        
        $main->AddListView(
        	-pos => [ 40, 160 ],
          -name => "lv",
          -font => $font,
        	-size => [ 385, 250 ],
        	-gridlines => 1,
          -hottrack => 0,
          -fullrowselect =>1
        	);

  $main->AddTextfield(
        -name   => "AddTask",
        -left   => 100,
        -top    => 130,
        -width  => 120,
        -height => 25,
        -prompt => "Your Task:",
    );



	$main->lv->InsertColumn( -item => 0, -text => "Tid", -width => 50);
	$main->lv->InsertColumn( -item => 1, -text => "Task", -width => 150);
	$main->lv->InsertColumn( -item => 2, -text => "Status", -width => 150); #-2
  $main->lv->InsertColumn( -item => 3, -text => "Action", -width => 30);

#prepare the query
sub fetchData {
my $sth = $dbh->prepare( "SELECT * FROM ToDO");
#execute the query
$sth->execute( );
## Retrieve the results of a row of data and print
print "\tQuery results:\n================================================\n";
my $i=1;
while ( ($id,$task,$status) = $sth->fetchrow_array( ) )  {
         print "$id $task $status\n";
         $main->lv->InsertItem(-item => $i-1, -text => ["$i","$task","$status","X"]);
         $i = $i+1;
}
warn "Problem in retrieving results", $sth->errstr( ), "\n"
        if $sth->err( );
}

sub insertData{
  
  my $sth = $dbh->prepare("INSERT INTO ToDo(Task) values (?)");
  $sth->execute($_[0]) or die $DBI::errstr;
#execute the query
}

sub delData{
  
  $textinfo = $main->lv->GetItemText($_[0],1);
  print "$textinfo is deleted\n";
  #$main->lv->DeleteItem($it);
  #$main->lv->Clear();
  
  my $sth = $dbh->prepare("DELETE FROM ToDo WHERE Task = ?");
  $sth->execute($textinfo) or die $DBI::errstr;
  print "Number of rows deleted :" + $sth->rows;
  $main->lv->Clear();
  fetchData();


}

fetchData();        


	$main->lv->TextColor(hex("FF0000"));
        
 
$main->Show;
Win32::GUI->Dialog();   # Enter message loop
exit;
 sub Button1_Click {  $main->lv->Clear();
                      $textfieldData = $main->AddTask->Text(); $|=1;
                      print "$textfieldData\n"; 
                      $main->AddTask->Clear();
                      insertData($textfieldData); fetchData();}
  sub lv_ItemClick {
             $it = $main->lv->SelectedItems();
             print "item clicked at $it\n";
             delData($it);
             
  }
  sub lv_ItemCheck {
             $it = $main->lv->SelectedItems();
             print "item clicked!!!\n";
  }
  sub lv_Click {
    $it = $main->lv->SelectedItems();
    print "it clicked...  $it\n";
  }                    
 #sub Button2_Click {$$main->lv->DeleteItem(0)}
sub Main_Terminate { $dbh->disconnect or warn "Disconnection error: $DBI::errstr\n";
-1; }  # Terminate message loopgrv
