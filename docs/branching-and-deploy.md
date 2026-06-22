# Branching and Deployment

This repo uses two long-lived branches:

- `main` = production source for https://w8df.peschpit.com/
- `dev` = developer/staging source for https://w8df-dev.peschpit.com/

GitHub's default branch is `dev` so day-to-day work and PRs land there first. Production stays intact until `dev` is promoted.

## Develop

```bash
git checkout dev
git pull origin dev
# make changes
git add .
git commit -m "Describe the change"
git push origin dev
./scripts/deploy-static.sh dev
```

## Promote dev to production

After reviewing https://w8df-dev.peschpit.com/:

```bash
./scripts/promote-dev-to-prod.sh
```

That script updates `main`, pushes it to GitHub, deploys `main` to https://w8df.peschpit.com/, and returns the working tree to `dev`.

## Manual deploy commands

```bash
./scripts/deploy-static.sh dev
./scripts/deploy-static.sh prod
```
