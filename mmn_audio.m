%% Very basic mismatched negativity task
% Using sound and either '5' triggers or serial trigers

%% Paradigm parameters
ndummies = 5;                                               % number of dummy volumes
slicespervol = 48;                                          % get this from MRI sequence
ntrials = 10;                                               % number of trials
mismatch_probability = 0.2;                                 % probability of mismatch trial
iti = 1;                                                    % intertrial interval (secs)
audioduration = 0.5;                                        % set sound stimulus duration (secs)
audiovol = 0.5;                                             % sound volume

%% Hardware parameters
usingserial = true;                                         % true or false for serial or '5' triggers
port = 1;                                                   % serial port for triggers
baudrate = 14400;                                           % serial port rate
if usingserial; start_serial; end                           % open/start serial port

%% PsychToolbox basic setup
PsychDefaultSetup(2);                                       % apply common Psychtoolbox parameters
InitializePsychSound;                                       % initialize Psychtoolbox audio

%% Keyboard setup
KbName('UnifyKeyNames');                                    % improve portability of your code acorss operating systems

%% Sound setup
if PsychPortAudio('GetOpenDeviceCount')                     % check to see if a PortAudio device is still open...
    PsychPortAudio('Close');                                % ...and close it
end
paudio = PsychPortAudio('Open');                            % open default sound playback device using lowest latency interface
pausioStatus = PsychPortAudio('GetStatus',paudio);          % Get audio device status
fs = pausioStatus.SampleRate;                               % ...extract sample rate
PsychPortAudio('Volume', paudio, 0.5);                      % set sound volume

%% Screen setup & open
Screen('Preference', 'SkipSyncTests', 1);                   % suppress warnings about VBL timing
scn = max(Screen('Screens'));                               % find second screen if connected
[pWin,wRect] = Screen('OpenWindow',scn);                    % open a display window (on second screen if connected)
[width,height] = Screen('WindowSize',pWin);                 % find window width & height
[x0,y0] = RectCenter(wRect);                                % find the centre of the window
Screen('FillRect', pWin);                                   % clear window with default backgroound colour
Screen('TextFont', pWin, 'Arial');                          % Set typeface
Screen('TextSize', pWin, 30);                               % Set fontsize
Screen('TextStyle', pWin, 0);                               % Set style as sum of: Normal=0, bold=1, italic=2, underline=4, outline=8, condense=32, extend=64
HideCursor;                                                 % Hide mouse pointer

% Setup key response in an adaptive way to work with *any* connected keypad
DrawFormattedText(pWin,'Please press left','center','center'); % draw text centred on screen
Screen('Flip', pWin);                                       % Display the window
[~,keycode,~] = KbPressWait;                                % Wait for key press
keyL = find(keycode);                                       % Store keycode
DrawFormattedText(pWin,'Please press right','center','center'); % draw text centred on screen
Screen('Flip', pWin);                                       % Display the window
[~,keycode,~] = KbPressWait;                                % Wait for key press
keyR = find(keycode);                                       % Store keycode
Screen('DrawText', pWin, '+' , x0,y0);                      % Draw fixation cross
Screen('Flip', pWin);                                       % Display the fixation cross

%% Setup stimuli
wavNormal = MakeBeep(440, audioduration, fs);               % make a beep
wavNormal = [wavNormal; wavNormal];                         % make it stereo
wavMismatch = rand(2,fs*audioduration);                     % make stereo white noise

ismismatch = rand(1,ntrials)<mismatch_probability;          % generate list of trial types

%% Wait for scanner
disp('Waiting for scanner')
if usingserial
    [s0,t0] = waitslice(port,dummies*slicespervol+1);       % wait for scanner serial trigger
else
    RestrictKeysForKbCheck(KbName('5'));                    % restrict the keys for just the scanner trigger
    for n=1:ndummies                                        % wait for dummy volumes
        [t0,keycode,delta_t]=KbPressWait;                   % wait for a volume
        disp(['Vol ' num2str(n) ' @ time ' num2str(t(n))])  % display timestamp & volume number
    end
end

%% Trial loop
RestrictKeysForKbCheck([keyL keyR]);                        % restrict the keys for keyboard input to the keys we want
for trial = 1:ntrials
    disp(['Trial ' num2str(trial)])                         % display the trial number
    
    switch ismismatch(trial)                                % prepare either normal or mismatch trial
        case false
            PsychPortAudio('FillBuffer',paudio,wavNormal);
        case true
            PsychPortAudio('FillBuffer',paudio,wavMismatch);
    end
    PsychPortAudio('Start',paudio, 1,0,1);                  % present stimulus
    [tstart(trial),~,~,tstop(trial)] = PsychPortAudio('Stop',paudio,3,1);     % ... and wait until the sound stops playing
    [keyt(trial),keycode,delta_t] = KbPressWait;            % wait for previous key release (important) and then wait for keypress
    key(trial) = find(keycode);                             % extract & save keypress
    WaitSecs(iti);                                          % Inter-trial interval
    
end

%% Tidy up & end
if usingserial; stop_serial; end                            % stop/close serial port
RestrictKeysForKbCheck([]);                                 % restore all keyboard keys
ShowCursor;                                                 % restore mouse pointer
Screen('Close',pWin);                                       % close display window. Atlernatively: Screen('CloseAll')
fname = datestr(now,30);                                    % make filename base on current date/time
save(fname)                                                 % save all data
