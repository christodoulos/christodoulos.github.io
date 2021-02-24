---
layout: default
---

Create a new workspace:

```
npx create-nx-workspace --preset=angular
npx: installed 190 in 21.814s
? Workspace name (e.g., org name)     infinite-loops
? Application name                    optistructure
? Default stylesheet format           CSS
? Default linter                      ESLint [ Modern linting tool ]
? Use Nx Cloud? (It's free and doesn't require registration.) Yes [Faster builds, run details, Github integration. Learn
 more at https://nx.app]
Creating a sandbox with Nx...
added 190 packages from 152 contributors and audited 191 packages in 8.35s

24 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities

new infinite-loops --preset=angular --no-interactive --appName=optistructure --style=css --linter=eslint --nxCloud --collection=@nrwl/workspace
✔ Packages installed successfully.
✔ Packages installed successfully.
CREATE jest.config.js
CREATE jest.preset.js
CREATE apps/optistructure/tsconfig.editor.json
CREATE apps/optistructure/tsconfig.json
CREATE apps/optistructure/src/favicon.ico
CREATE apps/optistructure/.browserslistrc
CREATE apps/optistructure/tsconfig.app.json
CREATE apps/optistructure/src/index.html
CREATE apps/optistructure/src/main.ts
CREATE apps/optistructure/src/polyfills.ts
CREATE apps/optistructure/src/styles.css
CREATE apps/optistructure/src/assets/.gitkeep
CREATE apps/optistructure/src/environments/environment.prod.ts
CREATE apps/optistructure/src/environments/environment.ts
CREATE apps/optistructure/src/app/app.module.ts
CREATE apps/optistructure/src/app/app.component.css
CREATE apps/optistructure/src/app/app.component.html
CREATE apps/optistructure/src/app/app.component.spec.ts
CREATE apps/optistructure/src/app/app.component.ts
CREATE .eslintrc.json
CREATE apps/optistructure/.eslintrc.json
CREATE apps/optistructure/jest.config.js
CREATE apps/optistructure/src/test-setup.ts
CREATE apps/optistructure/tsconfig.spec.json
CREATE apps/optistructure-e2e/.eslintrc.json
CREATE apps/optistructure-e2e/cypress.json
CREATE apps/optistructure-e2e/tsconfig.e2e.json
CREATE apps/optistructure-e2e/tsconfig.json
CREATE apps/optistructure-e2e/src/fixtures/example.json
CREATE apps/optistructure-e2e/src/integration/app.spec.ts
CREATE apps/optistructure-e2e/src/plugins/index.js
CREATE apps/optistructure-e2e/src/support/app.po.ts
CREATE apps/optistructure-e2e/src/support/commands.ts
CREATE apps/optistructure-e2e/src/support/index.ts
UPDATE angular.json
UPDATE package.json
UPDATE .vscode/extensions.json
UPDATE nx.json
✔ Packages installed successfully.
    Successfully initialized git.
CREATE infinite-loops/nx.json
CREATE infinite-loops/tsconfig.base.json
CREATE infinite-loops/README.md
CREATE infinite-loops/.editorconfig
CREATE infinite-loops/.gitignore
CREATE infinite-loops/.prettierignore
CREATE infinite-loops/.prettierrc
CREATE infinite-loops/angular.json
CREATE infinite-loops/package.json
CREATE infinite-loops/decorate-angular-cli.js
CREATE infinite-loops/tools/tsconfig.tools.json
CREATE infinite-loops/tools/generators/.gitkeep
CREATE infinite-loops/.vscode/extensions.json
CREATE infinite-loops/apps/.gitkeep
CREATE infinite-loops/libs/.gitkeep

———————————————————————————————————————————————

UPDATE nx.json

>  NX   NOTE  Nx Cloud has been enabled

  Your workspace is currently public. Anybody with code access can view the workspace on nx.app.
  You can connect the workspace to your Nx Cloud account at https://nx.app/orgs/workspace-setup?accessToken=ZjVmMzMzNjMtMDY5OC00MzgxLTg0MGQtNGU3YWM1NWNkMWQ1fHJlYWQtd3JpdGU=. (You can do this later.)


———————————————————————————————————————————————


>  NX   NOTE  First time using Nx? Check out this interactive Nx tutorial.

  https://nx.dev/angular/tutorial/01-create-application

  Prefer watching videos? Check out this free Nx course on YouTube.
  https://www.youtube.com/watch?v=2mYLe9Kp9VM&list=PLakNactNC1dH38AfqmwabvOszDmKriGco
```

Create new plain repo on Github

…or create a new repository on the command line

```
echo "# infinite-loops" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:christodoulos/infinite-loops.git
git push -u origin main
```

…or push an existing repository from the command line

```
git remote add origin git@github.com:christodoulos/infinite-loops.git
git branch -M main
git push -u origin main
```
