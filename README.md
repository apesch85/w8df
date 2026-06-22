# W8DF / SMARS Website

Static public landing page for the Southern Michigan Amateur Radio Society (SMARS), W8DF, in Battle Creek, Michigan.

The page preserves key club information from the original W8DF site while presenting it with a retro field-radio / 1950s broadcast style.

## Contents

- Club meeting, breakfast, and coffee information
- VE testing schedule and license resources
- Membership details
- Repeaters and local nets
- Club officers and coordinators
- Crossroads Hamfest details
- Links to FEEDBACK newsletters, code practice, swap shop, constitution, W1AW, and public-service resources

## Deployment

Currently deployed through nginx at:

https://w8df.peschpit.com/

The site is a single static `index.html` file.

## Branching and deployment

- `main` is production and deploys to https://w8df.peschpit.com/
- `dev` is the development/staging branch and deploys to https://w8df-dev.peschpit.com/
- Use `./scripts/deploy-static.sh dev` to publish dev changes.
- Use `./scripts/promote-dev-to-prod.sh` to promote reviewed dev work to production.

See `docs/branching-and-deploy.md` for details.
