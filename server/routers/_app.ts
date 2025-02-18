import { z } from 'zod';
import { procedure, router } from '../trpc';
import prisma from '@/lib/db';

export const appRouter = router({
  hello: procedure
    .input(
      z.object({
        text: z.string(),
      }),
    )
    .query((opts) => {
      return {
        greeting: `hello ${opts.input.text}`,
      };
    }),
  room: procedure
    .input(
      z.object({
        room: z.string(),
      })
    )
    .query(async (opts) => {
      const id = opts.input.room;
      const room = findOrCreateRoom(id);
      return { room };
    })
});

async function findOrCreateRoom(id: string) {
  const room = await prisma.room.findUnique({where: {id}})
  if (room) {
    return room;
  }
  return await prisma.room.create({data: {id}});
}

// export type definition of API
export type AppRouter = typeof appRouter;