import prisma from '$lib/server/prisma';
import { error } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { Prisma } from '@prisma/client';

export const load: PageServerLoad = async ({ params, parent, depends, locals: { supabase } }) => {
  depends('supabase:auth');

  const owner = (await supabase.auth.getUser()).data.user?.id;
  if (!owner) return;
  try {
    return {
      boards: await prisma.boards.findMany({
        where: {
          owner,
        },
      }),
    };
  } catch (err) {
    if (err instanceof Prisma.PrismaClientKnownRequestError) {
      error(404, `Not found: ${err.message}`);
    }
  }
};

export const actions = {
  createBoard: async ({ request, locals: { supabase } }) => {
    const owner = (await supabase.auth.getUser()).data.user?.id;
    if (!owner) return;
    const data = await request.formData();
    const name = String(data.get('name'));
    await prisma.boards.create({
      data: {
        name,
        owner,
      },
    });
  },
};
