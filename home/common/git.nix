{ ... }: {
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      alias = {
        ad = "add";
        br = "branch";
        st = "status";
        cm = "commit";
        co = "checkout";
        sw = "switch";
        di = "diff";
      };
    };
  };
}

