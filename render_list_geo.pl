#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Std;
use Math::Trig;
use YAML::Tiny;

my $options = {};
getopts("n:l:m:f:F:h", $options);

if ($options->{h}) {
    print "options: (x,X,y,Y,z,Z - required, no checks, small letters should be less)\n";
    print "  -n <n>         number of used concurrent threads\n";
    print "  -l <l>         maximum system load (defaults to 16)\n";
    print "  -m <m>         name of map\n";
    print "  -f <f>         force rerender\n";
    print "  -F <F>         config file";
    print "\n";
    exit;
}

unless ($options->{F} && -e $options->{F}) {
    print "File config.yml doesn't exist";
    exit;
}

my ($z, $Z, $zoom, $x, $X, $y, $Y, $n, $cmd);
my $bulkSize=8;
# Open the config
my $yaml = YAML::Tiny->read($options->{F})->[0];

print "\nRendering started at: ";
system("date");
print("\n");

foreach my $k (keys %{$yaml}) {
    my $v = $yaml->{$k};
    if (($v->{x} || int($v->{x})==0) &&
        ($v->{X} || int($v->{X})==0) &&
        ($v->{y} || int($v->{y})==0) && 
        ($v->{Y} || int($v->{Y})==0) &&
        ($v->{z} || int($v->{z})==0) && 
        ($v->{Z} || int($v->{Z})==0)) {
        print "\nRendering for $k started at: ";
        system("date");
        print("\n");
        $z = $v->{z};
        $Z = $v->{Z};
        for my $iz ($v->{z}..$v->{Z}) {
	    $zoom = 1 << $iz;
	    $x = int($zoom * ($v->{x} + 180) / 360);
	    $X = int($zoom * ($v->{X} + 180) / 360);
	    $y = int($zoom * (1 - log(tan($v->{y}*pi/180) + sec($v->{y}*pi/180))/pi)/2);
	    $Y = int($zoom * (1 - log(tan($v->{Y}*pi/180) + sec($v->{Y}*pi/180))/pi)/2);
	    #some stupid magic: aligning max range values to the border of meta-bundles (caused by internal bug of render_list)
	    $X=(int($X/$bulkSize)+1)*$bulkSize-1;
	    $y=(int($y/$bulkSize)+1)*$bulkSize-1;
	    $n = 2;
	    #be careful! y and Y used in reversed order
	    $cmd="render_list -a -z ".$iz." -Z ".$iz." -x ".$x." -X ".$X." -y ".$Y." -Y ".$y;
	    if ($options->{n}) {$cmd = $cmd." -n ".$options->{n}};
	    if ($options->{m}) {$cmd = $cmd." -m ".$options->{m}};
	    if ($options->{l}) {$cmd = $cmd." -l ".$options->{l}};
            if ($options->{f}) {$cmd = $cmd." -f ".$options->{f}};
	    system($cmd);
	    print("Zoom factor: ".$iz." finished at : ");
            system("date");
            print("\n");
        }
    } else {
        print "\nError in your config file";
    }
}
print "\nRendering finished at : ";
system("date");
print ("\n");
