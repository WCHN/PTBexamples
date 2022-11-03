%% Keyboard KbQueue demo
% Shows how to use KbQueue commands for key response
% Note that per PTB help use of KbQueueXXX commands is NOT compatible with
% KbWait etc
%
% See also: http://psychtoolbox.org/docs/KbQueueDemo

%% PsychToolbox basic setup
PsychDefaultSetup(2);                                   % apply common Psychtoolbox parameters

%% Keyboard setup
KbName('UnifyKeyNames');                                % improve portability of your code acorss operating systems
KbQueueCreate                                           % create a keyboard queue
KbQueueStart                                            % start the keyboard queue recording

%% Screen setup
Screen('Preference', 'SkipSyncTests', 1);               % suppress warnings about VBL timing
scn = max(Screen('Screens'));                           % find second screen if connected
[pWin,wRect] = Screen('OpenWindow',scn,[0 0 0]);        % open a display window
[width,height] = Screen('WindowSize',pWin);             % find window width & height
[x0,y0] = RectCenter(wRect);                            % find the centre of the window
Screen('TextFont', pWin, 'Arial');                      % set typeface
Screen('TextSize', pWin, 30);                           % set fontsize
Screen('TextStyle',pWin, 0);                            % set style as sum of: Normal=0, bold=1, italic=2, underline=4, outline=8, condense=32, extend=64

%% Wait for keypresses
DrawFormattedText(pWin,'Please press LEFT','center','center',[0, 130, 150],[],[],[],3.3); % draw text
t0 = Screen('Flip', pWin);                              % display the window and record timestamp
keypressed = 0;
while ~keypressed                                       % loop while no keypress found...
    [keypressed,firstpress,firstrelease,lastpress,lastrelease] = KbQueueCheck; % ...read the keyboard queue
end
KbName(firstpress)                                      % print the key name to the command window
keyleft = find(firstpress);                             % extract and save key code
t1 = firstpress(find(firstpress));                      % extract and save the corresponding timestamp
RT = t1-t0                                              % calculate reaction time (and print to command window)

DrawFormattedText(pWin,'Please press RIGHT','center','center',[0, 130, 150],[],[],[],3.3);
t0 = Screen('Flip', pWin);                              % Display the window
keypressed = 0;
while ~keypressed                                       % loop while no keypress found...
    [keypressed,firstpress,firstrelease,lastpress,lastrelease] = KbQueueCheck; % ...read the keyboard queue
end
KbName(firstpress)                                      % print the key name to the command window
keyright = find(firstpress);                            % extract and save key code
t1 = firstpress(find(firstpress));                      % extract and save the corresponding timestamp
RT = t1-t0                                              % calculate reaction time (and print to command window)
% RestrictKeysForKbCheck([keyleft keyright]);             % restrict the keys for keyboard input to the keys we want
keylist = zeros(1,256);                                 % make a
keylist([keyleft keyright]) = 1;                        % keylist vector
KbQueueCreate([],keylist)                               % re-create a keyboard queue with restricted keylist
KbQueueStart                                            % start the keyboard queue recording

DrawFormattedText(pWin,'Thanks. Please press some keys...','center','center',[0, 130, 150],[],[],[],3.3); % draw text
t0 = Screen('Flip', pWin);                              % display the window and record timestamp
WaitSecs('UntilTime',t0+5)                              % wait for 5 secs

[keypressed,firstpress,firstrelease,lastpress,lastrelease] = KbQueueCheck; % read the keyboard queue and display keypresses if any
if keypressed
    ix = find(firstpress);
    for n=1:length(ix)
        disp(['first press ' KbName(ix(n)) ' @ ' num2str(firstpress(ix(n))-t0) ', released @ ' num2str(firstrelease(ix(n))-t0)])
    end
    ix = find(lastpress);
    for n=1:length(ix)
        disp(['last press ' KbName(ix(n)) ' @ ' num2str(lastpress(ix(n))-t0) ', released @ ' num2str(lastrelease(ix(n))-t0)])
    end
else
    disp('No keypresses')
end

%% Tidy up & end
KbQueueStop                                             % stop keyboard queue recording
KbQueueRelease                                          % close keyboard queue
Screen('Close',pWin)                                    % close display window. Atlernatively: Screen('CloseAll')
