%% Very basic scanner trigger demo
% Waits for 5 scanner triggers - printing a message to the Matlab command
% window for each trigger

%% PsychToolbox basic setup
PsychDefaultSetup(2);                                   % apply common Psychtoolbox parameters

%% Keyboard setup
KbName('UnifyKeyNames');
activeKeys = [KbName('5')];                             % Numeric keypad '5' key for scanner triggers
RestrictKeysForKbCheck(activeKeys);                     % Restrict to just scanner triggers
ListenChar(2);                                          % Suppress keypresses to Matlab command window

%% Wait for scanner
for n=1:5                                               % wait for 5 volumes
    [t(n),keycode,delta_t]=KbPressWait;                 % wait for a volume
    disp(['Vol ' num2str(n) ' @ time ' num2str(t(n))])  % display timestamp & volume number
end

%% Tidy up & End
RestrictKeysForKbCheck([]);                             % Restore all keys
ListenChar(1)                                           % Restore keypresses to command window
