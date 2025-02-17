import { PrismaClient } from '@prisma/client'

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const g: { prisma?: PrismaClient } = global as any;

// Avoid creating a new PrismaClient on every hot reload in development
let prisma: PrismaClient
if (process.env.NODE_ENV === 'production') {
  prisma = new PrismaClient()
} else {
  if (!g.prisma) {
    g.prisma = new PrismaClient()
  }
  prisma = g.prisma
}

export default prisma
