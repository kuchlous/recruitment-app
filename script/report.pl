#!/usr/bin/perl

#############################################################################################
# Author:      MIRAFRA TECHNOLOGIES PVT LTD(C)                                              #
# Description: - This script is used to email all actions/activities done by an individual  #
#              when accessing to recruitment apps.                                          #
#              - Along with this, it will also notify you the remote ip address.(Just to see#
#              who else is using recuitment apps from outside                               #
#              - It will send you an report in html format. Please try to open it in html   #
#              mode only.                                                                   #
#              - In case you have any question, please write to hemant@mirafra.com          #
#############################################################################################


use Data::Dumper;
use Getopt::Long;

# Subroutine to get email names from command line option '-mail_to'
sub get_email_names() {
  my $opt    = shift;
  my $recp;
  foreach my $i ( @{$opt->{MAIL_TO} } ) {
    $recp .= $i . "\@mirafra.com, ";
  }
  chop($recp);
  chop($recp);
  return $recp;
}

# Subroutine to parse command line options
sub parse_options() {
  my $Option = shift;
  my @argv   = @ARGV;
  GetOptions ( 'log_file=s' => \$Option->{LOG_FILE}, 'mail_to=s@' => \$Option->{MAIL_TO}, 'help|h' => \$Option->{HELP} );

  if ( $Getopt::Long::error || $Option->{HELP} || ( scalar ( @argv ) == 0 ) ) {
  	print "\nUSAGE: $0 -log_file <log file path> -mail_to <xyz> -mail_to <abc>\n\n";
  	exit;
  }
}

# Subroutine to generate headers to html file which will be feeded to email file
sub generate_headers_HTML_FILE() {
  my ( $FILE ) = @_;
  print $FILE "<META http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"> <style type=\"text/css\"> #summary_table {border: 1px solid black; border-collapse: collapse;} #summary_table th {border: 1px solid black; text-align: left; background: #B8B8B8;} #summary_table td {border: 1px solid black; } </style>";
  print $FILE "<body>";
}

# Subroutine to generate contents to send email
sub send_mail() {
  my ( $summary_file, $recepients ) = @_;
  open ( HEADER, "> header" );
   print HEADER "Mime-Version: 1.0\n";
   print HEADER "Content-type: text/html; charset=\"iso-8859-1\"\n";
   print HEADER "From: recruitment-no-reply\n";
   print HEADER "To: $recepients\n";
   print HEADER "Subject: Remote IP mapping report for recruitment\n";
  close ( HEADER );

  my $email_send_cmd = "cat header $summary_file | /usr/lib/sendmail -t";

  # Executing email sending command
  `$email_send_cmd`;
}

sub delete_junk_files() {
  my ( $summary_file, $header_file ) = @_;

  my $delete_summary_file_cmd = "rm -rf $summary_file";
  my $delete_header_file_cmd  = "rm -rf $header_file";

  `$delete_summary_file_cmd`;
  `$delete_header_file_cmd`;
}


# Subroutine from where execution begins and all activity is done inside it
sub main () {
  my %Options;
  &parse_options ( \%Options );
  my $recepients  = &get_email_names ( \%Options );
  
  my @today       = localtime ( time );
  my @ystday      = localtime ( time - 86400 );
  $today[5]       = $today[5]  + 1900;
  $ystday[5]      = $ystday[5] + 1900;
  $today[4]       = $today[4]  + 1;
  $ystday[4]      = $ystday[4] + 1;
  if ( $today[4]  < 10 ) { $today[4]  = "0" . $today[4];  }
  if ( $today[3]  < 10 ) { $today[3]  = "0" . $today[3];  }
  if ( $ystday[4] < 10 ) { $ystday[4] = "0" . $ystday[4]; }
  if ( $ystday[3] < 10 ) { $ystday[3] = "0" . $ystday[3]; }
  my $today       = "$today[5]-$today[4]-$today[3]";
  my $ystday      = "$ystday[5]-$ystday[4]-$ystday[3]";
  my $ip_name_mapping;
  my $ip_remote_addr_mapping;
  my $mapping_read         = 0;
  my $ip_mapping_file_name = "ip_mapping_$ystday.txt";
  my $summary_report_name  = "summary_report_$today.html";

  if ( -e "./$ip_mapping_file_name") {
  	print "Reading IP-Name mapping from file $ip_mapping_file_name..";
  	$ip_name_mapping  = do "./$ip_mapping_file_name";
  	$mapping_read     = 1;
  }

  my $data;
  my $name_data;
  unless ( $mapping_read ) {
    print "Reading IP-Name mapping from file \"$Options{LOG_FILE}\".....";
  }

  # Opening log file to read activities for an individual
  open ( FH, "< $Options{LOG_FILE}" ) || die "Can not open file \"$Options{LOG_FILE}\" for reading.";
  my $time;
  my $action;
  my $report;
  while ( <FH> ) {
  	my @temp;
    if ( /Controller/ && /#/ && ( /$today/ || /$ystday/ ) ) {
      @temp = ();
      s/\)//g;
      @temp = split ( /\s+/, $_);
      $action = $temp[1];
      $time = $temp[5] . " " . $temp[6];
      $data->{$temp[5] . " " . $temp[6]} = $temp[1] . " " . $temp[3] unless ( $temp[1] =~ "ApplicationController" );
    }
    if ( /EmployeesController#login/ && !$mapping_read ) {
      my $line   = <FH>;
      if ( $line =~ m/\"login\"\=\>\"(.*)\"\,/ ) {
        my $login_name = $1;
        # 115.254.51.1 : Mirafra static IP
        # 61.95.193.231 : TI static IP
        if ( $temp[3]  =~ /192.168.1./ || $temp[3]  =~ /115.254.51.1/ || 
             $temp[3]  =~ /61.95.193.231/ || $temp[3] =~ /192.168.2./ ) {
          $ip_name_mapping->{$temp[3]}        = $login_name;
        } else {
          $ip_remote_addr_mapping->{$temp[3]} = $login_name;
        }
      }	else {
        print "No login name found\n";
      }
    }
    if (/Employee: (.*)$/ && $action) {
      my $employee = $1;
      if (not defined $report->{$employee}->{$action}) {
        $report->{$employee}->{$action} = 1;
      }
      else {
        $report->{$employee}->{$action} = $report->{$employee}->{$action} + 1;
      }
    }
  }

#  foreach my $key ( keys ( %$ip_remote_addr_mapping ) ) {
#    foreach my $key1 ( keys ( %$data ) ) {
#      my @temp = split ( /\s+/, $data->{$key1} );
#      if ( $key eq $temp[1] ) {
#        if ( not defined $report->{$ip_remote_addr_mapping->{$key}}->{$temp[0]} ) {
#          $report->{$ip_remote_addr_mapping->{$key}}->{$temp[0]} = 1;
#        } else {
#          $report->{$ip_remote_addr_mapping->{$key}}->{$temp[0]} = $report->{$ip_remote_addr_mapping->{$key}}->{$temp[0]} + 1;
#        }
#      }
#    }
#  }

  my $maxs;
  foreach my $key ( keys %$report ) {
    foreach my $key1 ( keys %{$report->{$key}} ) {
      if ( not defined $maxs->{$key1} ) {
        $maxs->{$key1} = $report->{$key}->{$key1};
      } else {
      	if ( $maxs->{$key1}  >= $report->{$key}->{$key1} ) {
        } else {
          $maxs->{$key1} = $report->{$key}->{$key1};
        }
      }
    }
  }	

  my @highest   = sort { $maxs->{$b} <=> $maxs->{$a} } keys %$maxs;

  # Getting array size
  my $max_count = $#highest + 1;
  my @highests  = @highest[0..$max_count];
  my $utj;

  foreach my $key( keys %$report ) {
    $utj->{$key} = 0;
    foreach my $job ( @highests ) {
      if ( defined $report->{$key}->{$job} ) {
        $utj->{$key} = $utj->{$key} + $report->{$key}->{$job};
      }
    }
  }
 
  my @act_emp    = sort { $utj->{$b} <=> $utj->{$a} } keys %$utj;

  open SUMMARY, "> ./$summary_report_name" || die "Can not open $summary_report_name for writing\n";
   # Will generate html headers for summary
   &generate_headers_HTML_FILE(SUMMARY);

   my $colspan   = $max_count + 1;
   print SUMMARY "<table width=\"100%\" id=\"summary_table\">";
   print SUMMARY "<tr> <td colspan=$colspan> <b> Total summary of individuals </b> <br/> <br /> </td> </tr> \n";
   print SUMMARY "<tr> \n";
   print SUMMARY "  <th style=\"min-width: 200px;\"> User/Actions </th> \n";
   foreach my $i ( 0..$max_count ) {
     my $page_name = $highests[$i];
     $page_name    =~ s/\#/ /;
     $page_name    =~ s/_/ /g;
     $page_name    =~ s/Requirements/Req/;
     $page_name    =~ s/Controller//;
     if ( $page_name ) {
       print SUMMARY "  <th style=\"min-width: 200px;\"> $page_name </th> \n";
     } else {
       print SUMMARY "  <th> &nbsp; </th> \n";
     }
   }

   print SUMMARY "</tr> \n";

   foreach my $key ( @act_emp ) {
     print SUMMARY "<tr> \n";
     print SUMMARY "  <td> $key </td>";
     foreach my $i ( 0..$max_count ) {
       if ( not defined $report->{$key}->{$highests[$i]} ) {
         $report->{$key}->{$highests[$i]} = 0;
       }
       my $val = $report->{$key}->{$highests[$i]};
       if ( $val ) {
         print SUMMARY "  <td> $val </td> \n";
       } else {
         print SUMMARY "  <td> &nbsp; </td> \n";
       }
     }
     print SUMMARY "</tr> \n";
   }
   print SUMMARY "</table> \n";
   print SUMMARY "</body> \n";
   print SUMMARY "</html> \n";

  close ( SUMMARY );

  # Will send email
  &send_mail ( $summary_report_name, $recepients );

  # Delete created files after sending email
  &delete_junk_files ( $summary_report_name, "./header" );
}



# Execution starts here
print "\n************** Execution Started ****************\n";
&main;
print "\n************** Execution Ended ******************\n";
# Execution ends here
