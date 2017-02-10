#!/usr/bin/perl
# Routine to parse an EDID
# Paul Jensen <pgj@movielabs.com>
# 20170205 (05-Feb-2017)

my @resolutions = (
    "???     ",
    "DMT0659 ",  #  4:3                  640x480p @ 59.94/60 Hz
    "480p    ",  #  4:3     8:9          720x480p @ 59.94/60 Hz
    "480pH   ",  # 16:9    32:37         720x480p @ 59.94/60 Hz
    "720p    ",  # 16:9     1:1         1280x720p @ 59.94/60 Hz
    "1080i   ",  # 16:9     1:1        1920x1080i @ 59.94/60 Hz
    "480i    ",  #  4:3     8:9    720(1440)x480i @ 59.94/60 Hz
    "480iH   ",  # 16:9    32:37   720(1440)x480i @ 59.94/60 Hz
    "240p    ",  #  4:3     8:9    720(1440)x240p @ 59.94/60 Hz
    "240pH   ",  # 16:9    32:37   720(1440)x240p @ 59.94/60 Hz
    "480i4x  ",  #  4:3     8:9       (2880)x480i @ 59.94/60 Hz
    "480i4xH ",  # 16:9    32:37      (2880)x480i @ 59.94/60 Hz
    "240p4x  ",  #  4:3     8:9       (2880)x240p @ 59.94/60 Hz
    "240p4xH ",  # 16:9    32:37      (2880)x240p @ 59.94/60 Hz
    "480p2x  ",  #  4:3     8:9         1440x480p @ 59.94/60 Hz
    "480p2xH ",  # 16:9    32:37        1440x480p @ 59.94/60 Hz
    "1080p   ",  # 16:9     1:1        1920x1080p @ 59.94/60 Hz
    "576p    ",  #  4:3    16:15         720x576p @ 50 Hz
    "576pH   ",  # 16:9    64:45         720x576p @ 50 Hz
    "720p50  ",  # 16:9     1:1         1280x720p @ 50 Hz
    "1080i25 ",  # 16:9     1:1        1920x1080i @ 50 Hz*
    "576i    ",  #  4:3    16:15   720(1440)x576i @ 50 Hz
    "576iH   ",  # 16:9    64:45   720(1440)x576i @ 50 Hz
    "288p    ",  #  4:3    16:15   720(1440)x288p @ 50 Hz
    "288pH   ",  # 16:9    64:45   720(1440)x288p @ 50 Hz
    "576i4x  ",  #  4:3    16:15      (2880)x576i @ 50 Hz
    "576i4xH ",  # 16:9    64:45      (2880)x576i @ 50 Hz
    "288p4x  ",  #  4:3    16:15      (2880)x288p @ 50 Hz
    "288p4xH ",  # 16:9    64:45      (2880)x288p @ 50 Hz
    "576p2x  ",  #  4:3    16:15        1440x576p @ 50 Hz
    "576p2xH ",  # 16:9    64:45        1440x576p @ 50 Hz
    "1080p50 ",  # 16:9     1:1        1920x1080p @ 50 Hz
    "1080p24 ",  # 16:9     1:1        1920x1080p @ 23.98/24 Hz
    "1080p25 ",  # 16:9     1:1        1920x1080p @ 25 Hz
    "1080p30 ",  # 16:9     1:1        1920x1080p @ 29.97/30 Hz
    "480p4x  ",  #  4:3     8:9       (2880)x480p @ 59.94/60 Hz
    "480p4xH ",  # 16:9    32:37      (2880)x480p @ 59.94/60 Hz
    "576p4x  ",  # 4:3     16:15      (2880)x576p @ 50 Hz
    "576p4xH ",  # 16:9    64:45      (2880)x576p @ 50 Hz
    "1080i25 ",  # 16:9     1:1        1920x1080i @ 50 Hz* (1250 Total)
    "1080i50 ",  # 16:9     1:1        1920x1080i @ 100 Hz
    "720p100 ",  # 16:9     1:1         1280x720p @ 100 Hz
    "576p100 ",  #  4:3     8:9          720x576p @ 100 Hz
    "576p100H",  # 16:9    32:37         720x576p @ 100 Hz
    "576i50  ",  #  4:3    16:15   720(1440)x576i @ 100 Hz
    "576i50H ",  # 16:9    64:45   720(1440)x576i @ 100 Hz
    "1080i60 ",  # 16:9     1:1        1920x1080i @ 119.88/120 Hz
    "720p120 ",  # 16:9     1:1         1280x720p @ 119.88/120 Hz
    "480p119 ",  #  4:3    16:15         720x480p @ 119.88/120 Hz
    "480p119H",  # 16:9    64:45         720x480p @ 119.88/120 Hz
    "480i59  ",  #  4:3     8:9    720(1440)x480i @ 119.88/120 Hz
    "480i59H ",  # 16:9    32:37   720(1440)x480i @ 119.88/120 Hz
    "576p200 ",  #  4:3    16:15         720x576p @ 200 Hz
    "576p200H",  # 16:9    64:45         720x576p @ 200 Hz
    "576i100 ",  #  4:3    16:15   720(1440)x576i @ 200 Hz
    "576i100H",  # 16:9    64:45   720(1440)x576i @ 200 Hz
    "480p239 ",  #  4:3     8:9          720x480p @ 239.76/240 Hz
    "480p239H",  # 16:9    32:37         720x480p @ 239.76/240 Hz
    "480i119 ",  #  4:3     8:9    720(1440)x480i @ 239.76/240 Hz
    "480i119H",  # 16:9    32:37   720(1440)x480i @ 239.76/240 Hz
    "720p24  ",  # 16:9     1:1         1280x720p @ 23.98/24 Hz
    "720p25  ",  # 16:9     1:1         1280x720p @ 25Hz
    "720p30  ",  # 16:9     1:1         1280x720p @ 29.97/30 Hz
    "1080p120",  # 16:9     1:1        1920x1080p @ 119.88/120 Hz
    "1080p100",  # 16:9     1:1        1920x1080p @ 100 Hz
    "720p24  ",  # 64:27    4:3         1280x720p @ 23.98/24 Hz
    "720p25  ",  # 64:27    4:3         1280x720p @ 25Hz
    "720p30  ",  # 64:27    4:3         1280x720p @ 29.97/30 Hz
    "720p50  ",  # 64:27    4:3         1280x720p @ 50 Hz
    "720p    ",  # 64:27    4:3         1280x720p @ 59.94/60 Hz
    "720p100 ",  # 64:27    4:3         1280x720p @ 100 Hz
    "720p120 ",  # 64:27    4:3         1280x720p @ 119.88/120 Hz
    "1080p24 ",  # 64:27    4:3        1920x1080p @ 23.98/24 Hz
    "1080p25 ",  # 64:27    4:3        1920x1080p @ 25Hz
    "1080p30 ",  # 64:27    4:3        1920x1080p @ 29.97/30 Hz
    "1080p50 ",  # 64:27    4:3        1920x1080p @ 50 Hz
    "1080p   ",  # 64:27    4:3        1920x1080p @ 59.94/60 Hz
    "1080p100",  # 64:27    4:3        1920x1080p @ 100 Hz
    "1080p120",  # 64:27    4:3        1920x1080p @ 119.88/120 Hz
    "720p24  ",  # 64:27    64:63       1680x720p @ 23.98/24 Hz
    "720p25  ",  # 64:27    64:63       1680x720p @ 25Hz
    "720p30  ",  # 64:27    64:63       1680x720p @ 29.97/30 Hz
    "720p50  ",  # 64:27    64:63       1680x720p @ 50 Hz
    "720p    ",  # 64:27    64:63       1680x720p @ 59.94/60 Hz
    "720p100 ",  # 64:27    64:63       1680x720p @ 100 Hz
    "720p120 ",  # 64:27    64:63       1680x720p @ 119.88/120 Hz
    "1080p24 ",  # 64:27    1:1        2560x1080p @ 23.98/24 Hz
    "1080p25 ",  # 64:27    1:1        2560x1080p @ 25Hz
    "1080p30 ",  # 64:27    1:1        2560x1080p @ 29.97/30 Hz
    "1080p50 ",  # 64:27    1:1        2560x1080p @ 50 Hz
    "1080p   ",  # 64:27    1:1        2560x1080p @ 59.94/60 Hz 
    "1080p100",  # 64:27    1:1        2560x1080p @ 100 Hz
    "1080p120",  # 64:27    1:1        2560x1080p @ 119.88/120 Hz
    "2160p24 ",  # 16:9     1:1        3840x2160p @ 23.98/24 Hz
    "2160p25 ",  # 16:9     1:1        3840x2160p @ 25Hz
    "2160p30 ",  # 16:9     1:1        3840x2160p @ 29.97/30 Hz
    "2160p50 ",  # 16:9     1:1        3840x2160p @ 50 Hz
    "2160p   ",  # 16:9     1:1        3840x2160p @ 59.94/60 Hz
    "2160p24 ",  # 256:135  1:1        4096x2160p @ 23.98/24 Hz
    "2160p25 ",  # 256:135  1:1        4096x2160p @ 25Hz
    "2160p30 ",  # 256:135  1:1        4096x2160p @ 29.97/30 Hz
    "2160p50 ",  # 256:135  1:1        4096x2160p @ 50 Hz
    "2160p   ",  # 256:135  1:1        4096x2160p @ 59.94/60 Hz
    "2160p24 ",  # 64:27    4:3        3840x2160p @ 23.98/24 Hz
    "2160p25 ",  # 64:27    4:3        3840x2160p @ 25Hz
    "2160p30 ",  # 64:27    4:3        3840x2160p @ 29.97/30 Hz
    "2160p50 ",  # 64:27    4:3        3840x2160p @ 50 Hz
    "2160p   "   # 64:27    4:3        3840x2160p @ 59.94/60 Hz
    );

# Short Audio Descriptor Audio Format
my @audioFormat = (
    "0???",   #  0 = RESERVED
    "LPCM",   #  1 = Linear Pulse Code Modulation (LPCM)
    "AC-3",   #  2
    "MPEG1",  #  3 = MPEG1 (Layers 1 and 2)
    "MP3",    #  4 = MP3
    "MPEG2",  #  5
    "AAC",    #  6
    "DTS",    #  7
    "ATRAC",  #  8
    "SACD",   #  9 = One-bit audio aka SACD
    "DD+",    # 10
    "DTS-HD", # 11
    "TrueHD", # 12 = MLP/Dolby TrueHD
    "DST",    # 13 = DST Audio
    "WMA",    # 14 = Microsoft WMA Pro
    "15???"   # 15 = RESERVED
    );


# See https://en.wikipedia.org/wiki/Color_temperature#Approximation
sub colorTemp {
    my $xe = 0.3366;
    my $ye = 0.1735;
    my $A0 = -949.86315;
    my $A1 = 6253.80338;
    my $t1 = 0.92159;
    my $A2 = 28.70599;
    my $t2 = 0.20039;
    my $A3 = 0.00004;
    my $t3 = 0.07125;

    my $n = ($_[0] - $xe) / ($_[1] - $ye);
    return $A0 + $A1 * exp(-$n/$t1) + $A2 * exp(-$n/$t2) + $A3 * exp(-$n/$t3);
}

print "EDID Parser V1.1\n";
my $fname = $ARGV[0];
open(FILE, "<$fname") || die ("can't open $fname");
binmode(FILE);
my $buf;
my $nchars = read(FILE, $buf, 8192);
printf ("File: %s; read %d characters\n", $fname, $nchars);
close(FILE);

my ($header, $mfg_id, $prod_code, $serial, $week, $year,
    $version, $revision, $vid_input, $hor, $vert,
    $gamma, $feature,
    $rgl, $bwl, $rx, $ry, $gx, $gy, $bx, $by, $wx, $wy,
    $et1, $et2, $mrt,
    $st1, $st2, $st3, $st4, $st5, $st6, $st7, $st8,
    $fill, $extension, $csum
    ) = unpack 'Q S2 L C22 S8 Z72 C2', $buf;

if ($nchars != 256 || $header != 0xffffffffffff00) {
    printf("Invalid EDID! header=0x%llX; size=%d\n", $header, $nchars);
    exit(-1);
}

printf("Manufacturer ID: '");
printf("%c", 0x40 + (($mfg_id >> 2) & 0x1f));
printf("%c", 0x40 + ((($mfg_id << 3) | (0x7 & ($mfg_id >> 13))) & 0x1f));
printf("%c", 0x40 + (($mfg_id >> 8) & 0x1f));
printf("' (raw=0x%4X)\n", $mfg_id);

printf("Product Code:      0x%4.4X\n", $prod_code);
printf("Serial Number: 0x%8.8X\n", $serial);
printf("Manufactured (year/week): %4d/%d\n", $year + 1990, $week);
printf("EDID revision: %d.%d\n", $version, $revision);

printf("Video Input Definition (raw=0x%2.2X):\n", $vid_input);
if ($vid_input & 0x80) {
    print "   Digital Input\n";
    print "   DFP 1.x compatible\n" if ($vid_input & 0x1);
} else {
    print "   Analog Input\n";
    print "   Serration of Vsync\n" if ($vid_input & 0x1);
    print "   Sync on Green\n"  if ($vid_input & 0x2);
    print "   Composite Sync supported\n" if ($vid_input & 0x4);
    print "   Separate Syncs supported\n" if ($vid_input & 0x8);
    print "   Display expects setup or pedestal\n" if ($vid_input & 0x10);
    print "   Signal Level Standard ";
    print("   0.700V,0.300V\n") if (($vid_input & 0x60) == 0x0);
    print("   0.714V,0.286V\n") if (($vid_input & 0x60) == 0x20);
    print("   1.000V,0.400V\n") if (($vid_input & 0x60) == 0x40);
    print("   0.700V,0.000V\n") if (($vid_input & 0x60) == 0x60);
}

printf("Display Dimensions: %d cm x %d cm\n", $hor, $vert);
printf("Gamma: %3.2f (raw=%d)\n", ($gamma + 100) / 100.0, $gamma);

printf("Display Features (raw=0x%2.2X):\n", $feature);
print("   Default GTF\n") if ($feature & 0x1);
print("   Preferred Timing Mode\n") if ($feature & 0x2);
print("   sRGB Default Color Space\n") if ($feature & 0x4);
print("   Monochrome Display\n") if (($feature & 0x18) == 0);
print("   RGB Color Display") if (($feature & 0x18) == 0x8);
print("   non-RGB Multi-Color Display") if (($feature & 0x18) == 0x10);
print("   Undefined Display\n") if (($feature & 0x18) == 0x18);
print("   Active Off Display\n") if ($feature & 0x20);
print("   Display Suspend\n") if ($feature & 0x40);
print("   Display Standby\n") if ($feature & 0x80);

printf("Phosphor Chromaticity:\n");
my $redx = (($rgl >> 6) & 0x3) | ($rx << 2);
my $redy = (($rgl >> 4) & 0x3) | ($ry << 2);
printf("   red:   (%f, %f)\n", $redx / 1024.0, $redy / 1024.0);
my $greenx = (($rgl >> 2) & 0x3) | ($gx << 2);
my $greeny = ($rgl & 0x3) | ($gy << 2);
printf("   green: (%f, %f)\n", $greenx / 1024.0, $greeny / 1024.0);
my $bluex = (($bwl >> 6) & 0x3) | ($bx << 2);
my $bluey = (($bw >> 4) & 0x3) | ($by << 2);
printf("   blue:  (%f, %f)\n", $bluex / 1024.0, $bluey / 1024.0);
my $whitex = (($bwl >> 2) & 0x3) | ($wx << 2);
my $whitey = ($bwl & 0x3) | ($wy << 2);
my $x = $whitex / 1024.0;
my $y = $whitey / 1024.0;
printf("   white: (%f, %f)  Color Temperature = %.0fK\n",
       $x, $y, colorTemp($x, $y));

printf("Extension Flag: 0x%2.2X\n", $extension);
printf("Checksum: 0x%2X", $csum);
my $checksum = 0;
for (my $i=0; $i<128; $i++) {
    $checksum += ord(substr($buf, $i, 1));
}
if ($checksum & 0xff) {
    printf(" (bad: %x)\n", $checksum);
} else {
    printf(" (OK)\n");
}

exit(0) if ($extension == 0);
$buf = substr($buf, 128);
my $tag = ord(substr($buf, 0, 1));
printf("Extension tag: 0x%2.2X\n", $tag);
exit(0) if ($tag != 2);

my ($etag, $erevision, $eoffset, $einfo, @cbuf) = unpack('C4 C124', $buf);
printf("CEA EDID Timing Extension Revision: %2.2X\n", $erevision);
printf("DTD offset: 0x%2.2X\n", $eoffset);
printf("DTD info:   0x%2.2X\n", $einfo);
printf("   total native formats: %d\n", $einfo & 0xF);
printf("   underscan\n") if ($einfo & 0x80);
printf("   basic audio\n") if ($einfo & 0x40);
printf("   YCbCr 4:4:4\n") if ($einfo & 0x20);
printf("   YCbCr 4:2:2\n") if ($einfo & 0x10);

for (my $i=0; $i<$eoffset-4;) {
    my $size = $cbuf[$i] & 0x1f;
    my $blocktype = $cbuf[$i] >> 5;
    printf("index[%3d] 0x%2.2X: nbytes=%d tag=", $i, $cbuf[$i], $size);
    if ($blocktype == 1) {
        printf("audio\n");
        my $nch = ($cbuf[$i+1] & 0x7) + 1;
        my $code = ($cbuf[$i+1] >> 3) & 0xf;
        printf("   Channels: %2d\n", $nch);
        printf("   Audio Format: %d\n", @audioFormat[$code]);
        printf("   Sampling Rates: ");
        my $freq = $cbuf[$i+2];
        printf("32kHz ") if ($freq & 0x1);
        printf("44kHz ") if ($freq & 0x2);
        printf("48kHz ") if ($freq & 0x4);
        printf("88kHz ") if ($freq & 0x8);
        printf("96kHz ") if ($freq & 0x10);
        printf("176kHz ") if ($freq & 0x20);
        printf("192kHz ") if ($freq & 0x40);
        print "\n";
        my $bps = $cbuf[$i+3];
        if ($code == 1) { # LPCM
            printf("   Sample size(s): ");
            printf("16-bit ") if ($bps & 0x1);
            printf("20-bit ") if ($bps & 0x2);
            printf("24-bit ") if ($bps & 0x4);
            printf("\n");
        } else {          # other audio formats
            printf("Bit rate: %d bits/second\n", $bps * 8192);
        }
    } elsif ($blocktype == 2) { # video
        printf("video\n");
        for ($j=0; $j<$size; $j++) {
            my $tmp = $cbuf[$i + $j + 1];
            printf("   0x%2.2X: resolution = %s ", $tmp, $resolutions[$tmp & 0x7f]);
            printf(" (native)") if ($tmp & 0x80);
            printf("\n");
        }
    } elsif ($blocktype == 3) { # vendor
        printf("vendor\n   ");
        for ($j=0; $j<$size; $j++) {
            printf("0x%2.2X ", $cbuf[$i + $j + 1]);
        }
        printf("\n");
    } elsif ($blocktype == 4) { # speaker
        printf("speaker\n");
        my $spk = $cbuf[$i + 1];
        printf("   Front Left / Front Right\n") if ($spk & 0x1);
        printf("   LFE\n") if ($spk & 0x2);
        printf("   Front Center\n") if ($spk & 0x4);
        printf("   Rear Left / Rear Right\n") if ($spk & 0x8);
        printf("   Rear Center\n") if ($spk & 0x10);
        printf("   Front Left Center / Front Right Center\n") if ($spk & 0x20);
        printf("   Rear Left Center / Rear Right Center\n") if ($spk & 0x40);
    } else {                    # reserved
        printf("reserved\n");
        for ($j=0; $j<$size; $j++) {
            printf("0x%2.2X ", $cbuf[$i + $j + 1]);
        }
        printf("\n");
    }
    $i += $size + 1;
}
