import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get()
  getHello(): object {
    return {
      message: 'LeadsMax API is running!',
      version: '1.0.0',
      endpoints: {
        auth: '/auth',
        users: '/users',
        products: '/products',
        posts: '/posts',
      },
    };
  }
}
