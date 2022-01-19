{ pkgs }:

{
  vim-misc = pkgs.vimUtils.buildVimPlugin {
	name = "vim-misc";
	src = pkgs.fetchFromGitHub {
	  owner = "justinrosenthal";
	  repo = "vim-misc";
	  rev = "8e8722557a3dd37cdd2ac995e87c886230c18f08";
	  sha256 = "05m7bb3jrid1mz3kziahsdjac10zjvbz201kjk7pfn0kp9hffplx";
	};
  };
}
