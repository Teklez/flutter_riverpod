// import { PassportStrategy } from '@nestjs/passport';
// import { Profile, Strategy, VerifyCallback } from 'passport-google-oauth20';
// import { Injectable } from '@nestjs/common';
// import { AuthService } from '../auth.service';

// @Injectable()
// export class GoogleStrategy extends PassportStrategy(Strategy, 'google') {
//   constructor(private readonly authService: AuthService) {
//     super({
//       clientID: process.env.GOOGLE_CLIENT_ID,
//       clientSecret: process.env.GOOGLE_CLIENT_SECRET,
//       callbackURL: 'http://localhost:3000/auth/google/callback',
//       scope: ['email', 'profile'],
//     });
//   }

//   async validate(
//     accessToken: string,
//     refrshToken: string,
//     profile: Profile,
//     done: VerifyCallback,
//   ): Promise<any> {
//     const user = this.authService.validateUser(
//       profile.emails[0].value,
//       profile.displayName,
//     );
//     return user || null;
//   }
// }
