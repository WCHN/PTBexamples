%% Very basic screen demo
% Opens a screen on the 2nd monitor (if available)
% Draws text and displays for 3 seconds
% Loads and draws an image for 3 seconds
% Closes screen

%% PsychToolbox basic setup
PsychDefaultSetup(2);                           % apply common Psychtoolbox parameters

%% Screen setup & open
Screen('Preference', 'SkipSyncTests', 1);       % suppress warnings about VBL timing
scn = max(Screen('Screens'));                   % find second screen if connected
[pWin,wRect] = Screen('OpenWindow',scn);        % open a display window
[width,height] = Screen('WindowSize',pWin);     % find window width & height
[x0,y0] = RectCenter(wRect);                    % find the centre of the window

%% Use screen

% Text style
Screen('FillRect', pWin);                       % fill window with default backgroound colour
Screen('TextFont', pWin, 'Arial');              % Set typeface
Screen('TextSize', pWin, 30);                   % Set fontsize
Screen('TextStyle', pWin, 0);                   % Set style as sum of: Normal=0, bold=1, italic=2, underline=4, outline=8, condense=32, extend=64
% Text i
Screen('DrawText', pWin, 'Simplest draw text' , x0,y0); % Draw the text @ x,y
Screen('Flip', pWin);                           % Display the window
WaitSecs(3);                                    % for 3 seconds
% Text ii
txt = 'Example centre-aligned multiline text, \n for example an instruction\n screen';
vSpacing = 1.5;                                 % line spacing
DrawFormattedText(pWin,txt,'center','center',[],[],[],[],vSpacing);
Screen('Flip', pWin);                           % Display the window
WaitSecs(3);                                    % for 3 seconds

% Image
im = imread('Mosquito.bmp');                    % read an image file
Screen('PutImage', pWin, im);                   % and load into window
Screen('Flip', pWin);                           % Display the window
WaitSecs(3)                                     % for 3 seconds

%% Tidy up & end
Screen('Close',pWin)                            % close display window. Atlernatively: Screen('CloseAll')
