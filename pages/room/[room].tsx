import { trpc } from "@/utils/trpc";
import { useRouter } from "next/router";

export default function RoomPage() {
  const router = useRouter();
  const room = router.query.room;
  if (Array.isArray(room)) return <div>One room id only</div>;
  if (!room) return <div>Room not found</div>;
  const query = trpc.room.useQuery({ room });
  return (
    <div>
      <div>room #{router.query.room}</div>
      <pre>{JSON.stringify(query.data, null, 2)}</pre>
    </div>
  );
}