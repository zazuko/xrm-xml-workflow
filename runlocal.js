import { createMapper } from './step.js'

const triplify = await createMapper()

const result = await triplify({
  mappingFile: './src-gen/characters.rml.ttl', outputFile: 'output-local.nt',
})

console.log(result)
