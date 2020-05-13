{
  type: 'object',
  required: ['content'],
  properties: {
    content: {
      type: 'object',
      required: [
        'title',
        'header_section',
        'sections',
        'topic_section',
        'notifications'
      ]
    }
  }
}
