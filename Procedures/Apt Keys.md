Adding a key to `/etc/apt/trusted.gpg.d` is **insecure** because it adds the key for all repositories. This is exactly why `apt-key` had to be _deprecated_.

## Short version

Do similar to what [Signal](https://signal.org/download/) does. If you want to use the key at `https://example.com/EXAMPLE.gpg` for a repository listed in `/etc/apt/sources.list.d/EXAMPLE.list`, use:

```bash
sudo mkdir -m 0755 -p /etc/apt/keyrings/

curl -fsSL https://example.com/EXAMPLE.gpg |
    sudo gpg --dearmor -o /etc/apt/keyrings/EXAMPLE.gpg

echo "deb [signed-by=/etc/apt/keyrings/EXAMPLE.gpg] https://example.com/apt stable main" |
    sudo tee /etc/apt/sources.list.d/EXAMPLE.list > /dev/null
```

```bash
# Optional (you can find the email address / ID using `apt-key list`)
sudo apt-key del support@example.com
```

```bash
# Optional (not necessary on most systems)
sudo chmod 644 /etc/apt/keyrings/EXAMPLE.gpg
sudo chmod 644 /etc/apt/sources.list.d/EXAMPLE.list
```

## Long version

While the deprecation notice recommends adding the key to `/etc/apt/trusted.gpg.d`, this is an insecure solution. To quote [this article from Linux Uprising](https://www.linuxuprising.com/2021/01/apt-key-is-deprecated-how-to-add.html):

> The reason for this change is that when adding an OpenPGP key that's used to sign an APT repository to `/etc/apt/trusted.gpg` or `/etc/apt/trusted.gpg.d`, the key is unconditionally trusted by APT on all other repositories configured on the system that don't have a `signed-by` (see below) option, even the official Debian / Ubuntu repositories. As a result, any unofficial APT repository which has its signing key added to `/etc/apt/trusted.gpg` or `/etc/apt/trusted.gpg.d` can replace any package on the system. So this change was made for security reasons (your security).

The proper solution is explained in [that Linux Uprising article](https://www.linuxuprising.com/2021/01/apt-key-is-deprecated-how-to-add.html) and on the [Debian Wiki](https://wiki.debian.org/DebianRepository/UseThirdParty#OpenPGP_certificate_distribution): Store the key in `/etc/apt/keyrings/` (or `/usr/share/keyrings/` if keys are managed by a package), and then reference the key in the apt source list.

Therefore, the appropriate method is as follows:

1. **Create directory**  
    Create the directory for PGP keys if it doesn't exist, and set its permissions. This step explicitly sets the [recommended permissions](https://wiki.debian.org/DebianRepository/UseThirdParty#OpenPGP_certificate_distribution), just in case you've changed your [umask](https://en.wikipedia.org/wiki/Umask) using sudo's `umask_override`. Creating the directory is actually only necessary in releases older than Debian 12 and Ubuntu 22.04, but it can't hurt to run this line either way.
    
    ```bash
    sudo mkdir -m 0755 -p /etc/apt/keyrings/
    ```
    
2. **Download key**  
    Download the key from `https://example.com/EXAMPLE.gpg` and store it in `/etc/apt/keyrings/EXAMPLE.gpg`. By giving options `-fsSL` to `curl` we enable error messages, ensure redirects are followed, and reduce output so you can see sudo's password prompt. The [Debian wiki explains](https://wiki.debian.org/DebianRepository/UseThirdParty#OpenPGP_Key_distribution) that you should dearmor the key (i.e. convert it from base64 to binary) for compatibility with older software.
    
    ```bash
    curl -fsSL https://example.com/EXAMPLE.gpg |
        sudo gpg --dearmor -o /etc/apt/keyrings/EXAMPLE.gpg
    ```
    
    Optionally, you can verify that the file you downloaded is indeed a PGP key by running `file /etc/apt/keyrings/EXAMPLE.gpg` and inspecting the output.
    
3. **Register repository**  
    A key has been added, but `apt` doesn't know about the repository yet. To add the repository, you should create a file in `/etc/apt/sources.list.d/` that describes how to use the repository, and where to find the key. The contents of the created file should look something like this:
    
    ```
    deb [signed-by=/etc/apt/keyrings/EXAMPLE.gpg] https://example.com/apt stable main
    ```
    
    The `signed-by` should link to the key you just downloaded.
    
    If a repository wants you to specify an `arch`, or you want to use multiple components (e.g. `main contrib`), the contents may instead be something like
    
    ```
    deb [arch=amd64 signed-by=/etc/apt/keyrings/EXAMPLE.gpg] https://example.com/apt stable main contrib
    ```
    
    If you are adapting from an existing repo, just copy what they have, and add the `signed-by=...` between the `[]`.
    
4. **(optional) Remove old key**  
    If you previously added a third-party key with `apt-key`, you should remove it. Run `sudo apt-key list` to list all the keys, and find the one that was previously added. Then, using the key's email address or fingerprint, run `sudo apt-key del support@example.com`.
    
5. **(optional) Force-set permissions**  
    If you have a custom `umask_override` set for `sudo`, or if you use ACLs, files will be created with different permissions than usual. In those cases, explicitly set permissions for `EXAMPLE.gpg` and `EXAMPLE.list` to `644`.
    

## Using the newer DEB822 format

The newer DEB822 format for specifying apt repositories is much nicer and easier to use, but not yet fully supported by all tools across all platforms.

### Short version

Instead of running the script mentioned above, run

```bash
echo "Types: deb
URIs: https://example.com/apt
Suites: stable
Components: main
Signed-By:
$(wget -O- https://example.com/EXAMPLE.gpg | sed -e 's/^$/./' -e 's/^/ /')" | sudo tee /etc/apt/sources.list.d/EXAMPLE.sources > /dev/null

# Optional (not necessary on most systems)
sudo chmod 644 /etc/apt/sources.list.d/EXAMPLE.sources
```

### Long version

Instead of using the one-line format for sources in `sources.list.d`, you can also use the newer multi-line format, DEB822. This format is easier to read for humans _and_ computers, and has been available in apt since 2015. [Debian and Ubuntu plan to use DEB822 as the default format starting late 2023.](https://discourse.ubuntu.com/t/spec-apt-deb822-sources-by-default/29333) [Repolib's documentation has a nice comparison and covers the motivation behind the new format.](https://repolib.readthedocs.io/en/latest/deb822-format.html). Additionally, [apt 2.2.4 and newer support embedding the public key directly in the `sources.list`](https://salsa.debian.org/apt-team/apt/-/merge_requests/176).

If you maintain a package hosted on a third-party repository, consider making an optional filled-in DEB822 `.sources` available to your users.

The reason this is currently a separate section in this answer instead of the main answer is that some still-supported versions of Debian and Ubuntu ship with old versions of apt. Specifically, Debian 10 LTS (EOL: 2024-06-30) and Ubuntu 20.04 (EOL: 2025-04-30) are too old, but Debian 11 and newer, and Ubuntu 22.04 and newer are good to go. Additionally, some tools that parse source files instead of wrapping around apt may not fully support all these features yet.

To switch from the one-line format to the DEB822 format, let's say you have the following two files:

- `/etc/apt/sources.list.d/example.list`:
    
    ```
    deb [signed-by=/etc/apt/keyrings/EXAMPLE.gpg] https://example.com/apt stable main
    ```
    
- `/etc/apt/keyrings/EXAMPLE.gpg`:  
    (Real keys should be much longer than this. This one is too short to be secure.)
    
    ```
    -----BEGIN PGP PUBLIC KEY BLOCK-----
    
    mI0EZWiPbwEEANPyu6pUQEydxvf2uIsuuYOernFUsQdd8GjPE5yjlxP6pNhVlqNo
    0fjB6yk91pWsoALOLM+QoBp1guC9IL2iZe0k7ENJp6o7q4ahCjJ7V/kO89mCAQ09
    yHGNHRBfbCo++bcdjOwkeITj/1KjYAfQnzH5VbfmgPfdWF4KqS/TmJP9ABEBAAG0
    G0phbmUgRG9lIDxqYW5lQGV4YW1wbGUub3JnPojMBBMBCgA2FiEEK8v49DttJG7D
    35BwcvTpbeNfCTgFAmVoj28CGwMECwkIBwQVCgkIBRYCAwEAAh4BAheAAAoJEHL0
    6W3jXwk4YLID/0arCzBy9utS8Q8g6FDtWyJVyifIvdloCvI7hqH51ZJ+Zb7ZLwwY
    /p08+Xnp4Ia0iliwqSHlD7j6M8eBy/JJORdypRKqRIbe0JQMBEcAOHbu2UCUR1jp
    jJTUnMHI0QHWQEeEkzH25og6ii8urtVGv1R2af3Bxi9k4DJwzzXc5Zch
    =8hwj
    -----END PGP PUBLIC KEY BLOCK-----
    ```
    

Then you can replace these two files with the single file `/etc/apt/sources.list.d/example.sources`:

```
Types: deb
URIs: https://example.com/apt
Suites: stable
Components: main
Signed-By:
 -----BEGIN PGP PUBLIC KEY BLOCK-----
 .
 mI0EZWiPbwEEANPyu6pUQEydxvf2uIsuuYOernFUsQdd8GjPE5yjlxP6pNhVlqNo
 0fjB6yk91pWsoALOLM+QoBp1guC9IL2iZe0k7ENJp6o7q4ahCjJ7V/kO89mCAQ09
 yHGNHRBfbCo++bcdjOwkeITj/1KjYAfQnzH5VbfmgPfdWF4KqS/TmJP9ABEBAAG0
 G0phbmUgRG9lIDxqYW5lQGV4YW1wbGUub3JnPojMBBMBCgA2FiEEK8v49DttJG7D
 35BwcvTpbeNfCTgFAmVoj28CGwMECwkIBwQVCgkIBRYCAwEAAh4BAheAAAoJEHL0
 6W3jXwk4YLID/0arCzBy9utS8Q8g6FDtWyJVyifIvdloCvI7hqH51ZJ+Zb7ZLwwY
 /p08+Xnp4Ia0iliwqSHlD7j6M8eBy/JJORdypRKqRIbe0JQMBEcAOHbu2UCUR1jp
 jJTUnMHI0QHWQEeEkzH25og6ii8urtVGv1R2af3Bxi9k4DJwzzXc5Zch
 =8hwj
 -----END PGP PUBLIC KEY BLOCK-----
```

Importantly, you **must** indent each line of the key block by (at least) one space, and you **must** put an indented `.` instead of an empty line. (Removing the empty line invalidates the key.) The script above does exactly that.

Finally, if you have a repo that specifies an exact path, such as

```
deb [signed-by=/etc/apt/keyrings/EXAMPLE.gpg] https://example.com/apt deb/
```

then your DEB822 **must** set `Suites: deb/` (which **must** end with a `/`) and it **must not** have a `Components:` line.

## Additional resources

- [Debian wiki: Instructions to connect to a third-party repository](https://wiki.debian.org/DebianRepository/UseThirdParty)
- [AskUbuntu: What commands (exactly) should replace the deprecated apt-key?](https://askubuntu.com/a/1307181/)
- [Unix SE: How to add a third-party repo. and key in Debian?](https://unix.stackexchange.com/a/582853/422587)
- `man 5 sources.list` in Ubuntu 22.04 or later