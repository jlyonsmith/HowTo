
To install **Flutter** on Linux, you can either perform a manual extraction (recommended for flexibility across distributions) or use Snap if you are on Ubuntu. [1](https://www.google.com/goto?url=CAESXwHrOzAVGoy5E3T1Vl27PBGr8Ff7Ho3SQ14pF_Up3ESYUFLJNOzGYA-oV1haQ1fGCgIk2yF1nedd-S5aETlJXBpwz4p5Ev8L-J_93cBLJ6a0wPP7oHksJWHXvcA8VMC_), [2](https://www.google.com/goto?url=CAEShQEB6zswFQjSuJmJ3rQS8YLwio7FMQcW-dOpylElV2FWf1aABxDrGojWjNprmjwtMsiYZ9PlbIgzA-eLh9OxH4d6uCcdD6ZDnEA52wtKu5D31Fm-i3SO8DDwy8F5QEi12qECMIJABXGmPQPnTRqLjUCsOXkM4FC9xChgyR9uquSJtQK23H70), [3](https://www.google.com/goto?url=CAESYwHrOzAVQfqpcrKB0wIsBxPHYr9kcsKmU1_fbJizlxUEw82oSuYEXfKEaxkAG6WBjLfY_W3H9uNOPaASCME269ulSBU73YIY3yAlLbC91kwMXrVu6WEaVe8bTux5H_5RQ0nYFg)

Here is the quick-start guide to manually installing the latest stable **Flutter SDK** on your system.

1. Install Prerequisites

Open your terminal and install the fundamental dependencies required by Flutter: [1](https://www.google.com/goto?url=CAESlgEB6zswFY4OYnEe5qu7dFqLG4bGhfbQzBZ10euRr-tivqHnmUwzkvNaXMoaII8es6v2BI2NZKosh0HdogfSH9VpjvCRgXPTdVipkpvqOGx5Pyt37bhxA-iW020vtaS2mrBpMeDyN-NdiNbLmLodWK-JpnJKkfRP-t9_fo8L_SHbfN9Uiu91z98mx-cDKJUtAZXzCNOqDLQ)

**Ubuntu / Debian-based:**

bash

```
sudo apt-get update
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
```

Use code with caution.

**Fedora / RHEL-based:**

bash

```
sudo dnf install -y wget git unzip xz zip curl
```

Use code with caution.

_(Optional)_ If you plan to build native **Linux desktop apps**, also install these compilation tools: [1](https://www.google.com/goto?url=CAEScQHrOzAVODS-MuWe3-AGzIMhdPe2xZen-_0kBNlMVG3dWHDojhWm57WtYixOPoFHORvWXrjtwSQaB4--MkocefOicNDkfof-hMUYrkhSW3E04O8y2fDU7ma5Aajy4-Psgu9e8NuoJ9sgnOI7hQ4ov-Bo)

```bash
# Ubuntu / Debian
sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

# Fedora
sudo dnf install -y clang cmake ninja-build pkgconf-pkg-config gtk3-devel lzma-sdk-devel
```

Use code with caution.

2. Download and Extract Flutter

Create a development folder, download the latest stable package, and extract it: [1](https://www.google.com/goto?url=CAESXwHrOzAVGoy5E3T1Vl27PBGr8Ff7Ho3SQ14pF_Up3ESYUFLJNOzGYA-oV1haQ1fGCgIk2yF1nedd-S5aETlJXBpwz4p5Ev8L-J_93cBLJ6a0wPP7oHksJWHXvcA8VMC_), [2](https://www.google.com/goto?url=CAESlgEB6zswFY4OYnEe5qu7dFqLG4bGhfbQzBZ10euRr-tivqHnmUwzkvNaXMoaII8es6v2BI2NZKosh0HdogfSH9VpjvCRgXPTdVipkpvqOGx5Pyt37bhxA-iW020vtaS2mrBpMeDyN-NdiNbLmLodWK-JpnJKkfRP-t9_fo8L_SHbfN9Uiu91z98mx-cDKJUtAZXzCNOqDLQ)

```bash
# Create and move to a development directory
mkdir ~/development
cd ~/development

# Download the Flutter SDK bundle 
curl -O https://googleapis.com

# Extract the archive
tar -xf flutter_linux_3.47.4-stable.tar.xz
```

Use code with caution.

3. Add Flutter to your PATH

To run `flutter` commands anywhere in your terminal, add it to your shell configuration file. [1](https://www.google.com/goto?url=CAESZAHrOzAVT78VgpipWcHhE01WPMUFh1uaS1MR0q13E-240-sldEGUl-fiPdkSHpbfWKipC6sQ6DM6uvkanU8lT7e6k_dac-pcBlU-aXY5_J7oVFi64tUOKXXc9p3IwqDjddH0ppk)

**For Bash (`~/.bashrc`):**

```bash
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Use code with caution.

**For Zsh (`~/.zshrc`):**

```bash
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Use code with caution.

4. Verify the Installation

Run the built-in diagnostic tool to verify that everything is installed correctly and see what dependencies (like Android Studio or VS Code) are still missing: [1](https://www.google.com/goto?url=CAESYwHrOzAVQfqpcrKB0wIsBxPHYr9kcsKmU1_fbJizlxUEw82oSuYEXfKEaxkAG6WBjLfY_W3H9uNOPaASCME269ulSBU73YIY3yAlLbC91kwMXrVu6WEaVe8bTux5H_5RQ0nYFg)

```bash
flutter doctor
```

---

Alternatively, **Ubuntu users** can install Flutter with a single command via Snap: [1](https://www.google.com/goto?url=CAESYwHrOzAVQfqpcrKB0wIsBxPHYr9kcsKmU1_fbJizlxUEw82oSuYEXfKEaxkAG6WBjLfY_W3H9uNOPaASCME269ulSBU73YIY3yAlLbC91kwMXrVu6WEaVe8bTux5H_5RQ0nYFg)

```bash
sudo snap install flutter --classic
```
