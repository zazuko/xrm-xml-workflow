import { interpreter } from 'node-calls-python'
import { Readable } from 'stream'

const py = interpreter

async function createMapper () {
  const pymodule = await py.import('python/run_morph_kgc.py')
  return ({ mappingFile, outputFile }) => py.callSync(pymodule, 'write_file',
    mappingFile, outputFile)
}

async function createReadable (mappingFile, outputFile) {
  console.log('createReadable', mappingFile, outputFile)
  const doMapping = await createMapper()

  const mappedTriples = doMapping({ mappingFile, outputFile })
  console.log(mappedTriples, 'triples mapped')

  return Readable.from([outputFile])
}

export { createReadable, createMapper }
