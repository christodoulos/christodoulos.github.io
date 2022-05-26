---
title: "Random Angular Tips"
date: 2022-05-26
tags: [Angular, Typescript]
---

## How to chain observables

If `observable2` depends on a finished `observable1` you can utilize `mergeMap` from `rxjs`:

```typescript
class SomeClass {
    ...
    onCredentials(credentials: Credentials) {
        this.auth
            .getSubjectToken(credentials)
            .pipe(
              map((res) => res.headers.get('X-Subject-Token') ?? ''),
              tap((subjectToken) => {
                localStorage.setItem('X-Subject-Token', subjectToken);
              }),
              mergeMap((subjectToken) => {
                return this.auth.getAuthorizedApplications(subjectToken);
              })
            )
            .subscribe((res) => console.log(res));
    }
    ...
}
```