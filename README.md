# Nix Flake Submodule

## Storing secrets in a Git submodule

It is currently not possible to easily store secrets in the Nix flake Git repository without using a dedicated secrets management like [agenix](https://github.com/ryantm/agenix) or [sops-nix](https://github.com/Mic92/sops-nix). Even if the secrets are encrypted with [git-crypt](https://github.com/AGWA/git-crypt) their decrypted content might be copied to the Nix store.

Before a Nix flake is evaluated the repository is copied to the Nix store. But the file's contents in the Git working tree are copied not the ones stored internally. If the `git-crypt` repository is currently *unlocked* this will copy the secrets to the Nix store.

There is a lot of discussion [\[1\]](https://github.com/NixOS/nix/pull/4922) [\[2\]](https://github.com/NixOS/nix/issues/4423#issuecomment-799270569) around including Git submodules in Nix flake but currently (Nix 2.31.3 as of time of writing) they are not included unless explicitly instructed to with [`?submodules=1`](https://nixos.wiki/wiki/Flakes#Building_flakes_from_a_Git_repo_url_with_submodules) or `submodules = true;`. With this secrets may now be stored in a Git submodule.

This repository includes includes two branches the default branch `main` and a separate branch `secrets` with completely unrelated histories. Secrets are stored on the branch `secrets` and this branch is included as a Git submodule in the branch `main`. Git submodules are usually used to include other Git repositories but may also refer to `./.` and reference commits of the current repository. (Git protects against submodules accessing arbitrary local files by default, this protection has to be disabled temporarily to create the submodule [`git -c protocol.file.allow=always submodule add -b secrets ./. secrets`](https://git-scm.com/docs/git-config#Documentation/git-config.txt-protocolnameallow).)
