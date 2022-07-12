
user_path = userpath();
user_path = user_path(1:end-1);

scripts_dir = fullfile(user_path, 'scripts');

if exist(scripts_dir, 'dir')
    scripts = genpath(scripts_dir);
    fprintf('Root <strong>''scripts''</strong> directory provides: \n');

    script_paths = strsplit(scripts, ':');
    for k = 1:length(script_paths)
        fprintf('    %s\n', script_paths{k});
    end

    addpath(scripts);
end

% Set some sane defaults for graphing:

set(0, 'defaultAxesXGrid', 'on');
set(0, 'defaultAxesYGrid', 'on');
set(0, 'defaultAxesZGrid', 'on');

% Make the output denser
format compact
