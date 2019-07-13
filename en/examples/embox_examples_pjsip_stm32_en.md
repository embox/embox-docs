#### Running Qt on STM32F7Discovery

Embox is able to run PJSIP on STM32F7-Discovery board with about 460 Kb RAM and 1Mb ROM.

Demo video  is [here](https://www.youtube.com/watch?v=W6wuEIZJf8o).

1. Configure Embox with `make confload-platform/pjsip/stm32f7cube`.

2. Edit configuration file `conf/mods.config` and type the following:
```
include platform.pjsip.cmd.simple_pjsua_imported(
    sip_domain="server",
    sip_user="username",
    sip_passwd="password"
)
```
where `server` is SIP server address (e.g. `sip.linphone.org`), `username` and `password` are your account on the specified server.

3. Build Embox with `make` and load into STM32F7-Discovery. You can see how to load Embox into STM32 board [here](https://github.com/embox/embox/wiki/Running-Embox-on-STM32xxDiscovery).

4. In Embox type "simple_pjsua_imported". After command execution, you will see something the following:
```
00:00:12.870    pjsua_acc.c  ....SIP outbound status for acc 0 is not active
00:00:12.884    pjsua_acc.c  ....sip:alexk2222@sip.linphone.org: registration success, status=200 (Registration succes
00:00:12.911    pjsua_acc.c  ....Keep-alive timer started for acc 0, destination:91.121.209.194:5060, interval:15s
```

5. Finally, you can make a call to Embox using a SIP phone (pjsua or some another, see [NOTE: Linphone](https://github.com/embox/embox/wiki/AUDIO-on-STM32/#note-linphone) below if you are using linphone).
Insert speakers to CN10 out and speak to the MEMS microphones (Micro Left and Micro Right located beside the display).

   For example, to make a call from to some linphone account do:
   ```
    embox>simple_pjsua_imported sip:some_account@sip.linphone.org
   ```


##### NOTE: Linphone
If you are using linphone, probably you will need some of the following things:
* Set up UDP (SIP)
* If you cannot register on a SIP server due to you are behind NAT, use `Behind NAT/ Firewall (use uPnP)`, read more [here](http://www.linphone.org/news/13/26/Linphone-UPnP.html).
* Disable all codecs except PCMU and PCMA

#### Record and play your voice

1. `make confload-platform/pjsip/stm32f7cube && make -j4`
2. In Embox type the following to record your voice:
```
record -r 16000 -c 2 -d 10000 -m C0000000
```
This command will create stereo 16000 Hz WAV with 10 s duration.

Play this WAV with:
```
play -m C0000000
```