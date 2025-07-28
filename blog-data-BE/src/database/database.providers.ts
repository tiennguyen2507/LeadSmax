import * as mongoose from 'mongoose';
import * as log from 'log-beautify';

// Use environment variable for MongoDB URI, fallback to local Docker MongoDB
const mongoUri =
  process.env.MONGO_URI ||
  'mongodb://leadsmax_user:leadsmax_pass@mongo:27017/leadsmax_db?authSource=admin';

export const databaseProviders = [
  {
    provide: 'DATABASE_CONNECTION',
    useFactory: (): Promise<typeof mongoose> => {
      return mongoose.connect(mongoUri).then((value) => {
        log.success_('Connect DB success!!');
        return value;
      });
    },
  },
];
