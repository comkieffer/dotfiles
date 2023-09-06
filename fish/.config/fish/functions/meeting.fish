function meeting --description 'Create a new jrnl entry for a meeting'
    jrnl < ~/.config/jrnl/templates/meeting.md
    jrnl @meeting -1 --edit
end
