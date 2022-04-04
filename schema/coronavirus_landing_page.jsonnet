{
  type: 'object',
  required: ['content'],
  properties: {
    content: {
      type: 'object',
      required: [
        'title',
        'meta_description',
        'topic_section',
        'notifications'
      ]
    }
  }
}
