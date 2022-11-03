%% Very basic keyboard demo
% Displays a message & waits for a keypress - twice
%
% See also: http://psychtoolbox.org/docs/KbDemo

%% PsychToolbox basic setup
PsychDefaultSetup(2);                                       % apply common Psychtoolbox parameters

%% Keyboard setup
KbName('UnifyKeyNames');                                    % improve portability of your code acorss operating systems
activeKeys = [KbName('LeftArrow') KbName('RightArrow')];    % specify key names of interest in the study
RestrictKeysForKbCheck(activeKeys);                         % restrict the keys for keyboard input to the keys we want

%% Screen setup
Screen('Preference', 'SkipSyncTests', 1);           % suppress warnings about VBL timing
scn = max(Screen('Screens'));                       % find second screen if connected
[pWin,wRect] = Screen('OpenWindow',scn);            % open a display window
[width,height] = Screen('WindowSize',pWin);         % find window width & height
[x0,y0] = RectCenter(wRect);                        % find the centre of the window

%% Wait for keypresses
Screen('TextFont', pWin, 'Arial');                  % Set typeface
Screen('TextSize', pWin, 30);                       % Set fontsize
Screen('TextStyle',pWin, 0);                        % Set style as sum of: Normal=0, bold=1, italic=2, underline=4, outline=8, condense=32, extend=64
Screen('FillRect', pWin);                           % fill window with default backgroound colour
Screen('DrawText', pWin,'Please press left', x0-100,y0);% Draw the text @ x,y
Screen('Flip', pWin);                               % Display the window
[t,keycode,~] = KbPressWait;                        % Wait for key press
keyleft = find(keycode);                            % Extract and save key code

Screen('FillRect', pWin);                           % fill window with default backgroound colour
Screen('DrawText', pWin,'Please press right',x0-100,y0);% Draw the text @ x,y
Screen('Flip', pWin);                               % Display the window
[t,keycode,~] = KbPressWait;                        % Wait for key press
keyright = find(keycode);                           % Extract and save key code


%% Tidy up & end
RestrictKeysForKbCheck([]);                         % remove restriction on valid keys
Screen('Close',pWin)                                % close display window. Atlernatively: Screen('CloseAll')
