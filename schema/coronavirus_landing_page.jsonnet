{
  type: 'object',
  required: ['content'],
  properties: {
    content: {
      type: 'object',
      required: [
        'title',
        'meta_description',
        'announcements_label',
        'topic_section',
        'notifications'
      ]
    }
  }
}
