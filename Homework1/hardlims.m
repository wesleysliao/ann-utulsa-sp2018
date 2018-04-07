function retval = hardlims (val)

  above = (val >= 0);
  below = (val < 0);
  
  retval = above + (-1.*below);
endfunction