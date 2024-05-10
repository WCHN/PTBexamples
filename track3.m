%% Eyetracking example script
%
% One long eyetrack recording with a message sent per trial
%
% NB ** requires ** image file 'Mosquito.bmp' to be available in order to run

%% Script parameters
ntrials = 10;
triallen = 6;
ITI = 2;
edf_filename = 'track3'; % the filename must be 8 characters or less & no spaces!

%% Eyetracker setup
if Eyelink('Initialize')~=0; return; end        % open a connection to the eyetracker PC
Eyelink('Openfile',edf_filename);               % create edf on the eyetracker PC
ret_val = Eyelink('StartRecording');

%% PsychToolbox basic setup
PsychDefaultSetup(2);                           % apply common Psychtoolbox parameters
Screen('Preference', 'SkipSyncTests', 1);       % suppress warnings about VBL timing
scn = max(Screen('Screens'));                   % find second screen if connected
[pWin,wRect] = Screen('OpenWindow',scn);        % open a display window
[wWidth,wHeight] = Screen('WindowSize',pWin);   % find window width & height
[x0,y0] = RectCenter(wRect);                    % find the centre of the window
Screen('FillRect', pWin);                       % fill window with default backgroound colour
Screen('TextFont', pWin, 'Arial');              % Set typeface
Screen('TextSize', pWin, 30);                   % Set fontsize
Screen('TextStyle', pWin, 0);                   % Set style as sum of: Normal=0, bold=1, italic=2, underline=4, outline=8, condense=32, extend=64
KbName('UnifyKeyNames');
KbQueueRelease;                                 % close keyboard queue
triggerKeys = KbName('5%');                     % Numeric keypad '5%' key for scanner triggers
ListenChar(0);                                  % disable character listening - to allow KbTriggerWait()

%% Wait for scanner
disp('Waiting for scanner...')
t0 = KbTriggerWait(triggerKeys);                % wait for a volume
Eyelink('Message','Scan start');
disp(['Scan start @ time ' num2str(t0)])        % display timestamp


%% Trial loop
for trial = 1:ntrials
    im = imread('Mosquito.bmp');
    Screen('PutImage', pWin, im);
    Screen('Flip', pWin);                       % stimulus onset
    Eyelink('Message','Trial %d onset',trial);  % message to eyetracker
    WaitSecs(triallen);
    Screen('FillRect', pWin);
    Screen('Flip', pWin);                       % stimulus offset
    Eyelink('Message','Trial %d offset',trial); % message to eyetracker
    WaitSecs(ITI);
end

%% PTB shutdown
ListenChar(1)                                   % re-enable keyboard
sca;                                            % close Psychtoolbox window

%% Eyetracker shutdown
Eyelink('StopRecording');                       % stop recording
Eyelink('Closefile');                           % close edf file
Eyelink('ReceiveFile');                         % copy edf file to the Stimulus PC
Eyelink('Shutdown');                            % close the connection to the eyetracker PC
if ~exist([edf_filename '.asc'], 'file')
    dos(['edf2asc ' edf_filename]);             % convert edf file to ASCII text
else
    error('Converted EDF file already exists; plaeas convert the file manually with edf2asc.')
end
