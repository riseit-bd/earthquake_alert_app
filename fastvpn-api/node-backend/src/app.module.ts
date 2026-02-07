import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT) || 3306,
      username: process.env.DB_USER || 'fastvpn',
      password: process.env.DB_PASSWORD || 'securepassword',
      database: process.env.DB_NAME || 'fastvpn_db',
      entities: [],
      synchronize: true, // Only for development
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
