import { Injectable } from '@nestjs/common';
import { writeFile, mkdir } from 'fs/promises';
import { join } from 'path';
import { existsSync } from 'fs';

@Injectable()
export class LocalStorageService {
  private readonly uploadDir = '/app/uploads'; // Thư mục trong Docker container
  private readonly baseUrl = process.env.BASE_URL || 'http://localhost:3000'; // URL cơ sở

  async uploadFile(
    file: Express.Multer.File,
    folder?: string,
  ): Promise<{ url: string; secure_url: string }> {
    try {
      // Tạo thư mục uploads nếu chưa tồn tại
      const uploadPath = folder ? join(this.uploadDir, folder) : this.uploadDir;
      if (!existsSync(uploadPath)) {
        await mkdir(uploadPath, { recursive: true });
      }

      // Tạo tên file unique
      const timestamp = Date.now();
      const randomString = Math.random().toString(36).substring(2, 15);
      const extension = file.originalname.split('.').pop();
      const filename = `${timestamp}_${randomString}.${extension}`;

      // Đường dẫn đầy đủ của file
      const filePath = join(uploadPath, filename);

      // Lưu file
      await writeFile(filePath, file.buffer);

      // Tạo URL hoàn chỉnh để truy cập file
      const fileUrl = `${this.baseUrl}/uploads/${folder ? folder + '/' : ''}${filename}`;

      return {
        url: fileUrl,
        secure_url: fileUrl, // Giữ tương thích với Cloudinary response
      };
    } catch (error) {
      throw new Error(`Failed to upload file: ${error.message}`);
    }
  }

  async deleteFile(fileUrl: string): Promise<void> {
    try {
      const { unlink } = await import('fs/promises');
      // Extract path from full URL
      const urlPath = new URL(fileUrl).pathname;
      const filePath = join(this.uploadDir, urlPath.replace('/uploads/', ''));
      await unlink(filePath);
    } catch (error) {
      console.error('Failed to delete file:', error);
    }
  }
}
