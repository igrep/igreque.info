MATCH (n)
OPTIONAL MATCH (n)-[r]-()
DELETE n,r;

CREATE (e:Episode { title: '宿命の対決！エースVSレジーナ', air_date: '2013-12-22' });

MATCH (episode:Episode { air_date: '2013-12-22' })
RETURN episode;

MATCH (episode:Episode)
WHERE episode.title = '宿命の対決！エースVSレジーナ'
CREATE (precure:Precure { precure_name: 'キュアエース' })
CREATE (episode)-[:FEATURED]->(precure);

MATCH (ace:Precure { precure_name: 'キュアエース' })
SET ace.human_name = '円亜久里'
// 複数行の文字列を入れるのにもっと見やすい方法はないかしら・・・
SET ace.transformation_line =
  'プリキュアドレスアップ！\n(キュピラッパー！)\n愛の切り札！ キュアエース！\n響け愛の鼓動！ドキドキプリキュア！\n美しさは正義の証し、ウインク一つで、\nあなたのハートを射抜いて差し上げますわ';

MATCH (episode:Episode)
WHERE episode.title = '宿命の対決！エースVSレジーナ'
CREATE (villain:Villain { name: 'レジーナ' })
CREATE (episode)-[:FEATURED]->(villain);

MATCH  (episode:Episode { title: '宿命の対決！エースVSレジーナ' }),
       (ace:Precure { precure_name: 'キュアエース' }),
       (regina:Villain { name: 'レジーナ' })
CREATE (battle:Battle)
CREATE (ace)-[:FOUGHT_IN]->(battle)<-[:FOUGHT_IN]-(regina)
CREATE (battle)-[:OCCURRED_IN]->(episode);

MATCH  (regina:Villain  { name: 'レジーナ' })
CREATE (episode:Episode { title: 'ジコチューの罠！マナのいないクリスマス！', air_date: '2013-12-15' })
CREATE (heart:Precure   { precure_name: 'キュアハート',       human_name: '相田マナ' })
CREATE (diamond:Precure { precure_name: 'キュアダイアモンド', human_name: '菱川六花' })

CREATE (kokuhaku:Kokuhaku)
CREATE (kokuhaku)-[:FOR]->(heart)
CREATE (diamond)-[:FORCE_TO { line: 'すきなのよ！いいかげん 正直にみとめなさい！'}]->(kokuhaku)
CREATE (regina)-[:TOLD { line: 'うるさいわね！そうよ すきよ！\nあたしだってマナがすき！悪い!?'}]->(kokuhaku)
CREATE (kokuhaku)-[:OCCURRED_IN]->(episode);

MATCH  (e45:Episode   { air_date: '2013-12-22' }),
       (e46:Episode   { air_date: '2013-12-15' })
CREATE (e46)-[:NEXT_OF]->(e45);

MATCH  (e45:Episode   { air_date:   '2013-12-15' }),
       (mana:Precure  { human_name: '相田マナ' }),
       (rikka:Precure { human_name: '菱川六花' })
CREATE (e45)-[:FEATURED]->(mana)
CREATE (e45)-[:FEATURED]->(rikka);

MATCH (regina:Villain { name: 'レジーナ' }),
      (mana:Precure  { human_name: '相田マナ' }),
      // 「-->」と書くことで、リレーションの部分を省略できるそうです！
      (regina)-->(kokuhaku:Kokuhaku)-->(mana),
      (kokuhaku)-[:OCCURRED_IN]->(kokuhaku_episode:Episode),

      episode_interval =
        (kokuhaku_episode) <-
        [:NEXT_OF*1..] - // kokuhaku_episode からいくつか前の
        (deai_episode:Episode), // もう、英語を考えるのが疲れました...

      (deai:Deai)-[:OCCURRED_IN]->(deai_episode),
      (regina)-->(deai)-->(mana)
RETURN LENGTH(episode_interval);
