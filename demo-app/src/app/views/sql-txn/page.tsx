import React from 'react';
import { NavigationPage } from '@/components/navigation/NavigationPage';
import { usePowerSync } from '@powersync/react';
import { LWWRecord } from '@/library/powersync/AppSchema';

// Jepsen transaction types

type invoke_r = {
  f: 'r'
  k: number,
  v: null
}
type invoke_append = {
  f: 'append'
  k: number,
  v: number
}

type completion_r = {
  f: 'r'
  k: number,
  v: null | string
}

type completion_append = {
  f: 'append'
  k: number,
  v: number
}

type invoke_op = {
  id: number
  type: "invoke"
  value: (invoke_append | invoke_r)[]
}

type completion_op = {
  id: number
  type: "ok" | "info" | "fail"
  value: (completion_append | completion_r)[]
  error?: string
}

const DEFAULT_INVOCATION: invoke_op = {
  id: 0,
  type: "invoke",
  value: [
    { f: "append", k: 0, v: 0 },
    { f: "r", k: 0, v: null },
    { f: "append", k: 0, v: 1 },
    { f: "r", k: 0, v: null }
  ]
}

const DEFAULT_COMPLETION: completion_op = {
  id: 0,
  type: "info",
  value: []
}

// page view
export default function SQLTxnPage() {
  const [txnStatus, setTxnStatus] = React.useState("unknown")
  const [completion, setCompletion] = React.useState(DEFAULT_COMPLETION)
  const powerSync = usePowerSync()

  // on form submit
  async function executeTxn(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()

    setTxnStatus("executing")
    setCompletion(DEFAULT_COMPLETION)

    const formData = new FormData(event.currentTarget)
    const invocation = formData.get('invocation') as string;
    const op: invoke_op = JSON.parse(invocation)

    await powerSync.writeTransaction(async (tx) => {
      try {
        const value: (completion_append | completion_r)[] = Array()
        for (const mop of op.value) {
          switch (mop.f) {
            case "append":
              const append_v = mop.v.toString()
              const update = await tx.execute('UPDATE lww SET v = ? WHERE id = ?', [append_v, mop.k])
              value.push(mop)
              console.debug({ update: update, mop: mop, op: op })
              break

            case "r":
              const select = await tx.getOptional<LWWRecord>('SELECT * FROM lww WHERE id = ?', [mop.k])
              const r_v = select ? select.v : null
              value.push({ ...mop, v: r_v })
              console.debug({ select: select, mop: mop, op: op })
              break
          }
        }

        const commit = await tx.commit()
        console.debug({ commit: commit, op: op })

        setCompletion({ ...op, type: "ok", value: value })
        setTxnStatus("ok")
      } catch (error: any) {
        try {
          await tx.rollback()
          setCompletion({ ...op, type: "fail", error: error.toString() })
          setTxnStatus("fail")
          console.error({ type: 'transaction error', op: op, error: error })
        } catch (error: any) {
          setCompletion({ ...op, type: "info", error: error.toString() })
          setTxnStatus("info")
          console.error({ type: 'rollback error', op: op, error: error })
        }
      }
    })
  }

  return (
    <NavigationPage title="SQL Txn">
      <div>
        <h3>Invocation</h3>
        <form
          onSubmit={executeTxn}>
          <textarea id='invocation' name='invocation' cols={80} rows={24} defaultValue={JSON.stringify(DEFAULT_INVOCATION, null, 2)} />
          <button id='submit' type='submit'>Execute Txn</button>
          <button id='reset' type='reset'>reset</button>
        </form>
      </div>

      <hr />

      {completion ? (
        <div>
          <h3>Completion</h3>
          <p id='status'>{txnStatus}</p>
          <pre id='completion'>
            {JSON.stringify(completion, null, 2)}
          </pre>
        </div>
      ) : null}
    </NavigationPage>
  );
}
