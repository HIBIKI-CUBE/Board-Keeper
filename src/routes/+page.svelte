<script lang="ts">
  import { enhance } from '$app/forms';
  import { communicating } from '$lib/communicating';
  import type { PageData } from './$types';
  import { afterUpdate } from 'svelte';

  export let data: PageData;

  let { boards, supabase } = data;
  $: ({ boards, supabase } = data);
  $: ownerPromise = (async () => (await supabase.auth.getUser()).data.user?.id)();

  afterUpdate(() => {
    $communicating = false;
  });
</script>

{#await ownerPromise then owner}
  {#if owner}
    {#if boards?.length}
      {#each boards as board}
        <a href="/board{board.id}">
          {board.name}
        </a>
      {/each}
    {/if}
    <form action="?/createBoard" method="post" use:enhance>
      <label for="name">ボードを作成</label>
      <input type="text" name="name" required />
      <input type="submit" value="作成" />
    </form>
  {/if}
{/await}
