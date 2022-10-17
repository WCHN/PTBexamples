%% Very basic audio recording script
% Records 2 seconds of audio on the default sound playback device

%% PsychToolbox basic setup
PsychDefaultSetup(2);                                   % apply common Psychtoolbox parameters

%% Sound setup
if PsychPortAudio('GetOpenDeviceCount')                 % check to see if a PortAudio device is still open...
    PsychPortAudio('Close');                            % ...and close it
end
audiodevlist=PsychPortAudio('GetDevices');
paudio = PsychPortAudio('Open',[],2);                   % open default sound capture device using lowest latency interface
status = PsychPortAudio('GetStatus',paudio);            % Get audio device status
fs = status.SampleRate;                                 % ...extract sample rate
                                                        % Display the audio device and API in use
disp(['Using API ' audiodevlist(status.InDeviceIndex).HostAudioAPIName ' on device ' audiodevlist(status.InDeviceIndex).DeviceName])

%% Recording setup
duration = 5;                                           % set sound capture duration (secs)
PsychPortAudio('GetAudioData', paudio, duration);       % setup recording buffer of required duration

%% Record sound
tstart = PsychPortAudio('Start',paudio,[],[],1);        % start recording and save start time
WaitSecs(duration);
status = PsychPortAudio('GetStatus',paudio);
tstop = status.EstimatedStopTime;                       % save stop time
wav = PsychPortAudio('GetAudioData', paudio);           % get recorded sound

%% Tidy up & end
PsychPortAudio('Close');                                % close audio device
