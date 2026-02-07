import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHealth(): string {
    return JSON.stringify({ status: 'UP', timestamp: new Date(), engine: 'NestJS' });
  }
}
