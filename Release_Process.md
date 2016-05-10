# Release Process

## Next day after release:
- Every fork merged to master?
- New version branches in all repositories from master branch?
- New version specific URLs created?
- All branches pushed to GitHub?
- New version Apache configuration complete?
- Updated network topology on wiki?
- All version numbers updated in source code?
- Version-specific database created?
- System configured to hit correct database?
- this goes away: - Configured web site /var/www directory and CORS?

Begin daily procedures…

## At least once a day:
- Data migrated from production database?
- Everything built successfully?
- All unit tests passing?
- All code deployed?
- Functional tests passing?
- Client released to TestFlight?

## At mobile (internal) release:
- Mobile client/Admin production ready?
- Master branch tagged for each product being released?
- Client released to TestFlight?
- Server: AdminUrl and CORS urls correct? 

## App is approved:
- (from daily step)Databases synced to production/Data Migration running between production and new version?
- App released to app store?
- Force upgrade working?
- Non versioned URL pointing to new version?
this goes away for future releases: 
- Previous release EC2 instances repurposed to mirror production for test purposes?
- Configration additions: 
	- Update AdminUrl in Server to public url (xxx.your-domain.com, not xxx-v1-2.your-domain.com), so that user referred from email doesn't see version url

## Several days after release:

- Previous release EC2 instances terminated?
