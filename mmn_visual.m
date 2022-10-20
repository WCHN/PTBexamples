%% Very basic mismatched negativity task
% Using images & '5' scanner triggers

%% Paradigm parameters
ndummies = 5;                                               % number of dummy volumes
ntrials = 10;                                               % number of trials
mismatch_probability = 0.2;                                 % probability of mismatch trial
iti = 1;                                                    % intertrial interval (secs)

%% PsychToolbox basic setup
PsychDefaultSetup(2);                                       % apply common Psychtoolbox parameters

%% Keyboard setup
KbName('UnifyKeyNames');                                    % improve portability of your code acorss operating systems

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

%% Setup stimuli
im = imread('tree.bmp');                                    % read an image file
pNormal = Screen('MakeTexture',pWin,im);                    % put into an offscreen buffer
im = imread('Mosquito.bmp');                                % read an image file
pMismatch = Screen('MakeTexture',pWin,im);                  % put into an offscreen buffer
mismatchtrial = rand(1,ntrials)<mismatch_probability;       % generate a vector of trial types

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

%% Wait for scanner
disp('Waiting for scanner')
RestrictKeysForKbCheck(KbName('5'));                        % restrict the keys for just the scanner trigger
for n=1:ndummies                                            % wait for dummy volumes
    [t0,keycode,delta_t]=KbPressWait;                       % wait for a volume
    disp(['Vol ' num2str(n) ' @ time ' num2str(t0)])        % display timestamp & volume number
end
Screen('DrawText', pWin, '+' , x0,y0);                      % Draw fixation cross
Screen('Flip', pWin);                                       % Display the fixation cross

%% Trial loop
RestrictKeysForKbCheck([keyL keyR]);                        % restrict the keys for keyboard input to the keys we want
[a,b]=Screen('PreloadTextures',pWin,[pNormal pMismatch]);
for trial = 1:ntrials
    disp(['Trial ' num2str(trial)])                         % display the trial number
    
    switch mismatchtrial(trial)                             % prepare either normal or mismatch trial
        case false
            Screen('DrawTexture',pWin,pNormal);
        case true
            Screen('DrawTexture',pWin,pMismatch);
    end
    [~,tstart(trial)] =Screen('Flip', pWin);                % Display the window
    [keyt(trial),keycode,delta_t] = KbPressWait;            % wait for previous key release (important) and then wait for keypress
    key(trial) = find(keycode);                             % extract & save keypress
    Screen('DrawText', pWin, '+' , x0,y0);                  % Draw fixation cross
    Screen('Flip', pWin);                                   % Display the fixation cross
    WaitSecs(iti);                                          % Inter-trial interval
    
end

%% Tidy up & end
RestrictKeysForKbCheck([]);                                 % restore all keyboard keys
ShowCursor;                                                 % restore mouse pointer
Screen('Close',pWin);                                       % close display window. Atlernatively: Screen('CloseAll')
fname = datestr(now,30);                                    % make filename base on current date/time
save(fname)                                                 % save all data
