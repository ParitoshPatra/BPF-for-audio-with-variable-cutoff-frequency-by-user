 clc
 clear all
 close all
 %loading the audio file
 [song1,fs2]=audioread('audiofilepath.mp3');
 [noise1,fs1]=audioread('audiofilepath.mp3');
 %converting stereo signal to mono signal
 noise=noise1(:,1);
 song=song1(:,1);
 N2=length(noise);
 N5=length(song);
 fs=44100;
 %zero padding of noise signal
 song=[song; zeros((N2-N5),1)];
 N3=length(song);
 %adding noise to song
 audio=(song+noise);
 N=length(audio);
 %frequency axis construction
 f3=fs*(0:N2-1)/N2;
 f4=fs*(0:N3-1)/N3;
 %FFT of the signals
 NO=fft(noise);
 SONG=fft(song);
 %plot of song spectrum and noise spectrum
 figure,subplot(2,1,1),plot(f3,abs(NO)),title('high frequency drums'),subplot(2,1,2),plot(f4,abs(SONG)),title('song');
 ts=1/fs;%sampling time
 t=0:ts:(length(audio)/fs)-ts;%time axis in seconds
 f2=fs*(0:N-1)/N;
 Aud=fft(audio);
%plot of input time domain and frequency domain
 11
 figure,subplot(2,1,1),plot(t,audio),title('time domain input signal(combined)'),xlabel('time inseconds'),ylabel('amplitude')
 subplot(2,1,2),plot(f2,abs(Aud)),title('input audiospectrum'),xlabel('frequency'),ylabel('magnitude');
 disp('playing input audio file...');
 sound(audio,fs);%playing input audio
 pause(length(audio)/fs);
 disp('audio spectrum between 1k to 5k');
 fcu=input(['enter the upper cut-off frequency:']);
 fcl=input(['enter the lower cut-off frequency:']);
 n1=12;
 disp('order is 12');
 ohmfcu=2*fs*tan(2*pi*fcu/(2*fs)); %prewarping technique
 ohmfcl=2*fs*tan(2*pi*fcl/(2*fs));
 bw=ohmfcu-ohmfcl;%bandwidth calculation
 cf=sqrt(ohmfcu*ohmfcl);%center frequency calculation
 [z1, p1, k1]=buttap(n1/2);%normalised low pass filter zeros,poles,gains
 [num1,den1] = zp2tf(z1,p1,k1);%transfer function
 [B1, A1]=lp2bp(num1,den1,cf,bw);%scale the lpf to bpf
 [bz1, az1]= bilinear(B1,A1,fs);%bilinear transformation
 [h1, f1]= freqz(bz1,az1,22.05*1000,fs);%frequency response
 % Magnitude Spectrum of filter
 figure,subplot(2,1,1)
 plot(f1,mag2db(abs(h1))),title('magnitude response offilter'),xlabel('frequency'),ylabel('Attenuation(db)')
 subplot(2,1,2)
 % phase Spectrum of filter
 plot(f1,angle(h1)),title('phase response of filter'),xlabel('frequency'),ylabel('phase angle')
 y1 = filter(bz1,az1,audio);
 Y1=fft(y1);
 %plot of output time domain and frequency domain
 figure,subplot(2,1,1),plot(t,y1),title('time domain output signal'),xlabel('time inseconds'),ylabel('amplitude')
 subplot(2,1,2),plot(f2,abs(Y1)),title('output audiospectrum'),xlabel('frequency'),ylabel('magnitude');
 %plot of pole-zero plot of normalised lpf and bpf
 figure,subplot(2,1,1)
 zplane(num1,den1),title(['Normalised low pass filt of order: ' num2str(n1/2)])
 subplot(2,1,2)
 zplane(bz1,az1),title(['bandpass filter of order: ' num2str(n1)]);
 disp('playing filtered audio...');
 sound(y1,fs);%playing output audio
 pause(length(audio)/fs);