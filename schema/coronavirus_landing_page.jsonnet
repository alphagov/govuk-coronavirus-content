{
  type: 'object',
  required: ['content'],
  properties: {
    content: {
      type: 'object',
      required: [
        'title',
        'meta_description',
        'header_section',
        'announcements_label',
        'announcements',
        'nhs_banner',
        'sections',
        'topic_section',
        'notifications'
      ]
    }
  }
}
