function Setup-NodeDevelopmentGlobalPackages {
    #npm install -g npm

    # updater
    iex "npm install -g npm-check-updates"

    # working with npm
    iex "npm install -g yarn"
    iex "npm install -g npx"
    iex "npm install -g np"
    iex "npm install -g npm-name-cli"

    # debugging
    iex "npm install -g ndb"
    iex "npm install -g node-inspector"
    iex "npm install -g nodemon"

    # general utilities
    iex "npm install -g pm2"
    iex "npm install -g localtunnel"
    iex "npm install -g tldr"
    iex "npm install -g now"
    iex "npm install -g spoof"
    iex "npm install -g fkill-cli"
    iex "npm install -g castnow"
    iex "npm install -g github-is-starred-cli"
    iex "npm install -g vtop"
    iex "npm install -g david"

    # react
    iex "npm install -g create-react-app"
    iex "npm install -g create-react-library"
    iex "npm install -g react-native-cli"

    # angular
    iex "npm install -g @angular/cli"

    # linting
    iex "npm install -g eslint"
    iex "npm install -g babel-eslint"
    iex "npm install -g eslint-config-standard"
    iex "npm install -g eslint-config-standard-react"
    iex "npm install -g eslint-config-standard-jsx"
    iex "npm install -g eslint-plugin-react"
    iex "npm install -g eslint-plugin-angular"
    iex "npm install -g eslint-config-prettier"
    iex "npm install -g eslint-plugin-prettier"
    iex "npm install -g prettier"
    iex "npm install -g standard"
    iex "npm install -g typescript"

    # Native Script
    iex "npm install -g nativescript"
}