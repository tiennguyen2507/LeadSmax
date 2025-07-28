import { Module } from '@nestjs/common';
import { ImageController } from './image.controller';
import { LocalStorageService } from './local-storage.service';

@Module({
  controllers: [ImageController],
  providers: [LocalStorageService],
  exports: [LocalStorageService],
})
export class ImageModule {}
